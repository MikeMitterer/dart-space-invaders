/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
     
part of spaceinvaders;

/// Creates all the [Sprite]s
///
/// If follows the Factory-Pattern. If the requested object does not exist it will be created.
/// If it exists it returns the already existing instance.
///
///     init() {
///         final Tank tank = spritefactory.tank;
///
///         ...
///         if (inputHandler.isDown(KeyCode.Left)) {
///
///             tank.moveLeft(speed: tankSpeed);
///         }
///    }
class SpriteFactory {
    final Logger _logger = new Logger('spaceinvaders.SpriteFactory');

    final dom.ImageElement _image = new dom.ImageElement(src: "images/invaders.png");

    final List<ToggleSprite> _alienSprites = new List<ToggleSprite>();

    Tank _tank;
    Swarm _swarm;
    Magazin _magazin;
    Cities _cities;

    void create() {
        if (_alienSprites.isEmpty) {

            // blue one
            _alienSprites.add(new ToggleSprite(new Sprite(_image,0, 0, 22, 16),new Sprite(_image,0, 16, 22, 16)));

            // pink Alien
            _alienSprites.add(new ToggleSprite(new Sprite(_image,22, 0, 16, 16),new Sprite(_image,22, 16, 16, 16)));

            // light blue Alien
            _alienSprites.add(new ToggleSprite(new Sprite(_image,38, 0, 24, 16),new Sprite(_image,38, 16, 24, 16)));
        }
    }

    Tank get tank => _tank ?? (_tank = new Tank(new Sprite(_image, 62, 0, 22, 16)));

    Swarm get swarm => _swarm ?? ( _swarm = new Swarm(new UnmodifiableListView(_createAliens())));

    Bullet get bullet => new Bullet(new Sprite(_image,120, 0, 1, 10));

    Magazin get magazin => _magazin ?? ( _magazin = new Magazin());

    Cities get cities => _cities ?? ( _cities = new Cities(new UnmodifiableListView( _createCities())));

    // - private ----------------------------------------------------------------------------------

    /// Creates the [Alien]-List
    List<Alien> _createAliens() {
        final List<Alien> aliens = new List<Alien>();

        // Alien-Rows in the swarm (see: create())
        //  pink (_alienSprites index 1)
        //  blue (_alienSprites index 0)
        //  blue (_alienSprites index 0)
        //  light-blue (_alienSprites index 2)
        //  light-blue (_alienSprites index 2)
        final List<int> spriteIndex = [1,0,0,2,2];

        if(Swarm.ROWS != spriteIndex.length) {
            throw new ArgumentError("Number of Swarm-Rows must be ${spriteIndex.length} but was ${Swarm.ROWS}");
        }
        for(int rows = 0;rows < Swarm.ROWS;rows++) {

            final ToggleSprite sprite = _alienSprites[spriteIndex[rows]];

            for(int cols = 0; cols < Swarm.COLS; cols++) {
                aliens.add(new Alien(new ToggleSprite(sprite._sprites[0],sprite._sprites[1])));
            }
        }

        return aliens;
    }

    /// Creates [Cities]
    List<City> _createCities() {
        List<City> cities = new List<City>();
        [1,2,3,4].forEach((_) {
            cities.add(new City(new Sprite(_image,84, 8, 36, 24)));
        });
        return cities;
    }
}

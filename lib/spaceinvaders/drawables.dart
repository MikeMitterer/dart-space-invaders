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

/// Base class for all the drawable (paintable) objects on the screen.
///
/// [Painter] uses this class for doing it's job
abstract class Drawable {
    /// The image that represents this [Drawable]
    Sprite get sprite;

    int get x;
    int get y;

    void draw(final Painter painter);
}

/// Mixin to move an object horizontally
class MoveHorizontale {
    int x = 0;
    void moveLeft({ final int speed: 1}) { x -= speed; }
    void moveRight({ final int speed: 1}) { x += speed; }
}

/// Mixin to move an object vertically
class MoveVertical{
    int y = 0;
    void moveUp({ final int speed: 1}) { y -= speed; }
    void moveDown({ final int speed: 1}) { y += speed; }
}

/// More or less a base implementation of [Drawable] plus
/// with + height.
abstract class ScreenObject implements Drawable {

    void draw(final Painter painter) { painter.draw(this); }

    int get width => sprite._width;
    int get height => sprite._height;

    /// Describes the [Drawable] as [Rectangle]
    math.Rectangle<num> get rect => new math.Rectangle<num>(x,y,width,height);

    /// Collision detection
    bool collidesWith(final ScreenObject so) => rect.intersects(so.rect);
}

/// The Tank can move left and right and shoots the [Alien]s
class Tank extends ScreenObject with MoveHorizontale,MoveVertical implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Tank');

    int hits = 0;

    final Sprite _sprite;

    Tank(this._sprite) {
        _logger.fine("Tank created!");
    }

    @override
    Sprite get sprite => _sprite;
}

/// The enemy - the Aliens are organized in a [Swarm]
class Alien extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Alien');

    final ToggleSprite _toggleSprite;

    int x = 0;
    int y = 0;

    bool killed = false;

    Alien(this._toggleSprite) {
        _logger.fine("Alien created!");
    }

    @override
    Sprite get sprite => _toggleSprite;

    void toggle() { _toggleSprite.toggle(); }

    @override
    void draw(Painter painter) {
        if(!killed) {
            painter.draw(this);
        }
    }
}

/// Collection of [Alien]s
class Swarm extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Swarm');

    static const int ROWS = 5;
    static const int COLS = 10;

    int _x = 0;
    int _y = 0;

    final UnmodifiableListView<Alien> aliens;

    int _width = 0;
    int _height = 0;

    Swarm(this.aliens) {
        _logger.fine("Swarm created!");
        _updatePosition();
    }

    @override
    Sprite get sprite => throw new UnsupportedError("Sprite is not supported for Swarm!");

    @override
    void draw(final Painter painter) {
        aliens.forEach((final Alien alien) => alien.draw(painter));
    }

    void toggle() { aliens.forEach( (final Alien alien) => alien.toggle() ); }

    int get x => _x;
    int get y => _y;

    int get moveWidth => aliens.first.width;

    void set x(final int value) {
        _x = value;
        _updatePosition();
    }

    void set y(final int value) {
        _y = value;
        _updatePosition();
    }

    void moveUp() {
        _y -= aliens.first.height;
        _updatePosition();
    }

    void moveDown() {
        _y += aliens.first.height;
        _updatePosition();
    }

    void moveRight() {
        _x += moveWidth;
        _updatePosition();
    }


    void moveLeft() {
        _x -= moveWidth;
        _updatePosition();
    }

    @override
    int get height => _height;

    @override
    int get width => _width;

    /// Bring new life to Alien (after Game restart)
    void resuscitate() {
        aliens.forEach((final Alien alien) => alien.killed = false);
    }

    void set width(final int value) {
        _width = value;
        _updatePosition();
    }

    UnmodifiableListView<Alien> getFrontAliens() {
        final List<Alien> front = new List<Alien>();
        for(int colIndex = 0;colIndex < COLS; colIndex++) {
            for(int rowIndex = ROWS;rowIndex > 0; rowIndex--) {
                final indexAlien = colIndex + ((rowIndex - 1) * COLS);
                final Alien alien = aliens[indexAlien];
                if(!alien.killed) {
                    front.add(alien);
                    break;
                }
            }
        }
        //_logger.info("IA ${front.length}");

        return new UnmodifiableListView<Alien>(front);
    }

    UnmodifiableListView<Alien> aliensAlive() {
        return new UnmodifiableListView<Alien>(aliens.where((final Alien alien) => !alien.killed));
    }

    /// Looks for the frontmost [Alien]
    Alien closestAlien() {
        Alien closest;
        int yPos = 0;
        aliensAlive().forEach((final Alien alien) {
            if(alien.y > yPos) {
                closest = alien;
                yPos = alien.y;
            }
        });
        return closest;
    }


    // - private ----------------------------------------------------------------------------------


    void _updatePosition() {

        _height = ((aliens.first.height * 1.5) * Swarm.ROWS).toInt();

        int index = 0;
        final int sectionWidth = (width ~/ Swarm.COLS);

        for(int rows = 0;rows < Swarm.ROWS;rows++) {
            for(int cols = 0; cols < Swarm.COLS; cols++) {

                final Alien alien = aliens[index];
                final int centerPos = (sectionWidth ~/ 2) - (alien.width ~/ 2 );

                alien.x = (x + centerPos + (cols * sectionWidth)).toInt();
                alien.y = (y + (rows * alien.height * 1.5) + 20).toInt();

                index++;
            }
        }
    }
}

/// City can be destroyed by [Alien]
class City extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.City');
    int x = 0;
    int y = 0;
    final Sprite _sprite;

    City(this._sprite);

    @override
    Sprite get sprite => _sprite;

    int get height => _sprite._height;
}

/// Holds (and draws!!!!) the [City] objects
///
/// Cities are drawn on [ImagePainter]. This makes it possible
/// to destroy parts of a [City]
class Cities extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Cities');

    int x = 0;
    int y = 0;

    int _width;
    int _height;

    ImagePainter _imagePainter;

    int buildCycle = 0;

    final UnmodifiableListView<City> _cities;

    Cities(this._cities) {
        final ScreenSize size = (new Screen()).size;
        _width = size.width;
        _height = _cities.first.height;

        _imagePainter = new ImagePainter(_width,_height);
    }

    int get length => _cities.length;

    int get width => _width;

    int get height => _height;

    set width(final int value) {
        _width = value;
        _updateCityPosition();
    }

    @override
    void draw(final Painter painter) {
        if(buildCycle < 5) {
            painter.save();
            // Draw it only on the first few cycles. This makes sure that
            // we can later on "damage" this layer
            _cities.forEach((final City city) => city.draw(_imagePainter));
            painter.restore();
            buildCycle++;
        }
        painter.drawImage(_imagePainter,0,y);
    }

    // Create damage effect on city-canvas
    void damage(num x,num y) {
        // round x, y position
        x = x.toInt();
        y = y.toInt();

        // draw damage effect to canvas
        _imagePainter.clearRect(x - 2, y - 2, 4, 4);
        _imagePainter.clearRect(x + 2, y - 4, 2, 4);
        _imagePainter.clearRect(x + 4, y, 2, 2);
        _imagePainter.clearRect(x + 2, y + 2, 2, 2);
        _imagePainter.clearRect(x - 4, y + 2, 2, 2);
        _imagePainter.clearRect(x - 6, y, 2, 2);
        _imagePainter.clearRect(x - 4, y - 4, 2, 2);
        _imagePainter.clearRect(x - 2, y - 6, 2, 2);

        // final ScreenSize size = (new Screen()).size;
        //
        // _context.setStrokeColorRgb(0,255,0);
        // _context.rect(x,y,6,6);
        // _context.stroke();
    }


    // TODO: implement sprite
    @override
    Sprite get sprite => null;

    bool isCityHit(final Bullet bullet) {
        final int canvasOffset = y; // transform y value to local coordinate system
        final math.Rectangle rectBullet = new math.Rectangle(bullet.x,bullet.y,bullet.width,(bullet.height ~/ 2));

        for(int index = 0;index < _cities.length;index++) {
            final City city = _cities[index];
            final math.Rectangle rectCity = new math.Rectangle(city.x,(city.y) + canvasOffset,city.width,(city.height));
            if(rectCity.intersects(rectBullet)) {

                // get image-data and check if opaque
                final dom.ImageData data = _imagePainter.getImageData(bullet.x, bullet.y - canvasOffset, 1, 1);
                if (data.data[3] != 0) {
                    damage(bullet.x, bullet.y - canvasOffset);
                    return true;
                }
            }
        }
        return false;
    }


    void _updateCityPosition() {

        // Every city has its on "section" or column
        final int section = width ~/ _cities.length;
        final int cityYPos = 0; //spritefactory.tank.y - spritefactory.cities.first.height * 2;

        for(int cityIndex = 0;cityIndex < _cities.length;cityIndex++) {
            _cities[cityIndex].x = (section * (cityIndex + 1)) - (section ~/ 2);
            _cities[cityIndex].y = cityYPos;
        }
    }

}

/// Bullet fired either by an [Alien] or by the [Tank].
/// A [Magazin] is used to hold the [Bullet]s
class Bullet extends ScreenObject with MoveVertical implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Bullet');

    int x = 0;
    int velocity = 10;

    final Sprite sprite;

    Bullet(this.sprite);

    void move() { y -= velocity; }
}

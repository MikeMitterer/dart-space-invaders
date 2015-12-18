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

/// [Sprite] represents the part of an [ImageElement] that can be drawn on the screen
class Sprite {
    final dom.ImageElement _image;

    final int _x, _y, _width, _height;

    /// [_image] holds all the Sprites.
    /// x,y,with,height are the coordinates for this Sprite in [_image]
    const Sprite(this._image, this._x, this._y, this._width, this._height);
}

/// This [Sprite] has two status - for example an [Alien] moving its arms up and down
class ToggleSprite implements Sprite {
    final Logger _logger = new Logger('spaceinvaders.ToggleSprite');

    final List<Sprite> _sprites = new List<Sprite>();

    int _activeSprite = 0;

    ToggleSprite(final Sprite first, final Sprite second) {
        _sprites.add(first);
        _sprites.add(second);
    }

    /// Switches between the two [Sprite]s
    void toggle() {_activeSprite = _activeSprite == 0 ? 1 : 0; }

    // - private -------------------------------------------------------------------------------------------------------

    @override
    int get _height => _sprites[_activeSprite]._height;

    @override
    dom.ImageElement get _image => _sprites[_activeSprite]._image;

    @override
    int get _width => _sprites[_activeSprite]._width;

    @override
    int get _x => _sprites[_activeSprite]._x;

    @override
    int get _y => _sprites[_activeSprite]._y;
}


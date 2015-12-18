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

/// Abstracts the size of [Screen].
///
/// It should not be necessary to pass [Screen] around if
/// only the [ScreenSize] is needed.
///
///     init(frameHandler,screensize,spritefactory);
class ScreenSize {
    int width;
    int height;
    ScreenSize(this.width, this.height);
}

/// Abstracted canvas class useful in games.
///
/// Implemented as Singleton so that we can "construct" it multiple times
///
///     main() {
///         final Screen screen = new Screen()..create();
///         final SpriteFactory spritefactory = new SpriteFactory()..create();
///         ...
///         void loop() {
///             ...
///             render(screen,spritefactory);
///         }
///     }
class Screen {
    final Logger _logger = new Logger('spaceinvaders.Screen');

    final int _width;
    final int _height;

    dom.CanvasElement _canvas;
    dom.CanvasRenderingContext2D _context;
    Painter _painter;

    static Screen _singleton = null;

    factory Screen({final int width: 500, final int height: 600}) {
        return _singleton ?? (_singleton = new Screen._internal(width,height));
    }

    /// Creates the necessary [CanvasElement] and [CanvasRenderingContext2D]
    void create() {
        if (_canvas == null) {
            _canvas = new dom.CanvasElement();
            _canvas.classes.add("si_canvas");

            _canvas.width = _width;
            _canvas.height = _height;

            _context = _canvas.getContext("2d");
            dom.document.body.append(_canvas);
        }
    }

    int get width => _canvas.width;

    int get height => _canvas.height;

    ScreenSize get size => new ScreenSize(width,height);

    /// Clears the drawing context
    ///
    ///     void render(final Screen screen,final SpriteFactory spritefactory) {
    ///         screen.clear()
    ///     }
    void clear() {
        _context.clearRect(0,0,width,height);
    }

    /// Every [ScreenObject] draws on this [Painter]
    Painter get painter => (_painter ?? (_painter = new Painter(_context)));

    // - private -------------------------------------------------------------------------------------------------------

    /// Private constructor. Necessary because [Screen] is a Singleton-Factory
    Screen._internal(this._width,this._height) {
        _logger.info("Screen created...");
    }
}

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

/// Paints on the Canvas
///
///     final Painter painter = screen.painter;
///     spritefactory.tank.draw(painter);
class Painter {
    static final Logger _logger = new Logger('spaceinvaders.Painter');

    final  dom.CanvasRenderingContext2D _context;
    Painter(this._context);

    /// Draws the given [Drawable]
    ///
    /// spritefactory.tank.draw(painter);
    ///
    void draw(final Drawable drawable) {
        _context.drawImageScaledFromSource(
        // source
            drawable.sprite._image,

            drawable.sprite._x,
            drawable.sprite._y,
            drawable.sprite._width,
            drawable.sprite._height,

        // target
            drawable.x,
            drawable.y,
            drawable.sprite._width,
            drawable.sprite._height);
    }

    void drawImage(final ImagePainter imagePainter,final num destX,final num destY) {
        _context.drawImage(imagePainter._canvas,destX,destY);
    }

    void save() { _context.save(); }
    void restore() { _context.restore(); }

}

/// Special form of [Painter]. It paints on its own canvas.
///
/// [Cities] are painting on this [Painter].
///
///     class Cities {
///         ...
///         Cities() {
///             _imagePainter = new ImagePainter(_width,_height);
///         }
///
///         void draw(final Painter painter) {
///             if(cycles < 1) {
///
///                 // Draw it only on the first few cycles. This makes sure that
///                 // we can later on "damage" this layer
///                 _cities.forEach((final City city) => city.draw(_imagePainter));
///
///                 cycles++;
///             }
///         painter.drawImage(_imagePainter,0,y);
///         }
///
///     }
class ImagePainter extends Painter {
    static final Logger _logger = new Logger('spaceinvaders.CityPainter');

    final dom.CanvasElement _canvas;

    factory ImagePainter(final int width,final int height) {
        return new ImagePainter._internal(new dom.CanvasElement(width: width,height: height));
    }

    ImagePainter._internal(final dom.CanvasElement canvas) : _canvas = canvas, super(canvas.getContext("2d")) {
        _logger.info("CityPainter created!");
    }

    void clearRect(int x,int y,int width, int height) {
        _context.clearRect(x,y,width, height);
    }

    dom.ImageData getImageData(int x,int y,int width, int height) => _context.getImageData(x,y,width,height);
}
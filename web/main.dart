library spaceinvaders;

import 'dart:collection';
import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:logging/logging.dart';

final Logger _logger = new Logger('layout-header-drawer-footer');

class Painter {
    final Logger _logger = new Logger('spaceinvaders.Painter');

    final  dom.CanvasRenderingContext2D _context;
    Painter(this._context);

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

    void drawImage(final dom.CanvasImageSource source,final num destX,final num destY) {
        _context.drawImage(source,destX,destY);
    }

    void save() { _context.save(); }
    void restore() { _context.restore(); }

}

class ScreenSize {
    int width;
    int height;
    ScreenSize(this.width, this.height);
}

/// Abstracted canvas class useful in games
/// Implemented as Singleton so that we can "construct" it multible times
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

    void clear() {
        _context.clearRect(0,0,width,height);
    }

    Painter get painter => (_painter ?? (_painter = new Painter(_context)));

    Screen._internal(this._width,this._height) {
        _logger.info("Screen created...");
    }
}

class Sprite {
    final dom.ImageElement _image;
    final int _x, _y, _width, _height;
    const Sprite(this._image, this._x, this._y, this._width, this._height);
}

class ToggleSprite implements Sprite {
    final Logger _logger = new Logger('spaceinvaders.ToggleSprite');

    final List<Sprite> _sprites = new List<Sprite>();

    int _activeSprite = 0;

    ToggleSprite(final Sprite first, final Sprite second) {
        _sprites.add(first);
        _sprites.add(second);
    }

    void toggle() {_activeSprite = _activeSprite == 0 ? 1 : 0; }

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

            _alienSprites.add(new ToggleSprite(new Sprite(_image,0, 0, 22, 16),new Sprite(_image,0, 16, 22, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,22, 0, 16, 16),new Sprite(_image,22, 16, 16, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,38, 0, 24, 16),new Sprite(_image,38, 16, 24, 16)));
        }
    }

    Tank get tank => _tank ?? (_tank = new Tank(new Sprite(_image, 62, 0, 22, 16)));

    Swarm get swarm => _swarm ?? ( _swarm = new Swarm(new UnmodifiableListView(_createAliens())));

    Bullet get bullet => new Bullet(new Sprite(_image,120, 0, 1, 10));

    Magazin get magazin => _magazin ?? ( _magazin = new Magazin());

    Cities get cities => _cities ?? ( _cities = new Cities(new UnmodifiableListView( _createCities())));

    // - private ----------------------------------------------------------------------------------

    List<Alien> _createAliens() {
        final List<Alien> aliens = new List<Alien>();
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

    List<City> _createCities() {
        List<City> cities = new List<City>();
        [1,2,3,4].forEach((_) {
            cities.add(new City(new Sprite(_image,84, 8, 36, 24)));
        });
        return cities;
    }
}

abstract class Drawable {
    Sprite get sprite;
    int get x;
    int get y;

    void draw(final Painter painter);
}

class MoveHorizontale {
    int x = 0;
    void moveLeft({ final int speed: 1}) { x -= speed; }
    void moveRight({ final int speed: 1}) { x += speed; }
}

class MoveVertical{
    int y = 0;
    void moveUp({ final int speed: 1}) { y -= speed; }
    void moveDown({ final int speed: 1}) { y += speed; }
}

class ValidRegion {
    final math.Rectangle _region = new math.Rectangle(0,0,0,0);
}

abstract class ScreenObject implements Drawable {

    void draw(final Painter painter) { painter.draw(this); }

    int get width => sprite._width;
    int get height => sprite._height;
}

class Tank extends ScreenObject with MoveHorizontale,MoveVertical implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Tank');

    final Sprite _sprite;

    Tank(this._sprite) {
        _logger.info("Tank created!");
    }

    @override
    Sprite get sprite => _sprite;

}

class Alien extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Alien');

    final ToggleSprite _toggleSprite;

    int x = 0;
    int y = 0;

    bool killed = false;

    Alien(this._toggleSprite) {
        _logger.info("Alien created!");
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
        _logger.info("Swarm created!");
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

    void set width(final int value) {
        _width = value;
        _updatePosition();
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

class Cities extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Cities');

    int x = 0;
    int y = 0;

    int _width;
    int _height;

    final dom.CanvasElement _canvas;
    dom.CanvasRenderingContext2D _context;
    Painter _painter;

    int cycles = 0;

    final UnmodifiableListView<City> _cities;

    Cities(this._cities) : _canvas = new dom.CanvasElement() {
        final ScreenSize size = (new Screen()).size;
        _width = size.width;
        _height = _cities.first.height;

        _canvas.width = width;
        _canvas.height = height;
        _context = _canvas.getContext("2d");
    }

    int get length => _cities.length;

    int get width => _width;

    int get height => _height;

    set width(final int value) {
        _width = value;
        _canvas.width = _width;
        _updateCityPosition();
    }

    @override
    void draw(final Painter screenPainter) {
        if(cycles < 5) {
            screenPainter.save();
            _cities.forEach((final City city) => city.draw(painter));
            screenPainter.restore();
            cycles++;
        }
        screenPainter.drawImage(_canvas,0,y);
    }

    // Create damage effect on city-canvas
    void damage(num x,num y) {
        // round x, y position
        x = x.toInt();
        y = y.toInt();

        // draw damage effect to canvas
        _context.clearRect(x - 2, y - 2, 4, 4);
        _context.clearRect(x + 2, y - 4, 2, 4);
        _context.clearRect(x + 4, y, 2, 2);
        _context.clearRect(x + 2, y + 2, 2, 2);
        _context.clearRect(x - 4, y + 2, 2, 2);
        _context.clearRect(x - 6, y, 2, 2);
        _context.clearRect(x - 4, y - 4, 2, 2);
        _context.clearRect(x - 2, y - 6, 2, 2);

//        final ScreenSize size = (new Screen()).size;
//
//        _context.setStrokeColorRgb(0,255,0);
//        _context.rect(x,y,6,6);
//        _context.stroke();
    }

    Painter get painter => (_painter ?? (_painter = new Painter(_context)));

    bool isCityHit(final Bullet bullet) {
        final int canvasOffset = y; // transform y value to local coordinate system
        final math.Rectangle rectBullet = new math.Rectangle(bullet.x,bullet.y,bullet.width,(bullet.height ~/ 2));

        for(int index = 0;index < _cities.length;index++) {
            final City city = _cities[index];
            final math.Rectangle rectCity = new math.Rectangle(city.x,(city.y) + canvasOffset,city.width,(city.height));
            if(rectCity.intersects(rectBullet)) {

                // get image-data and check if opaque
                final dom.ImageData data = _context.getImageData(bullet.x, bullet.y - canvasOffset, 1, 1);
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

class Bullet extends ScreenObject with MoveVertical implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Bullet');

    int x = 0;

    final Sprite sprite;

    Bullet(this.sprite);
}

class Magazin {
    final List<Bullet> _bullets = new List<Bullet>();

    void addBullet(final Bullet bullet) {
        _bullets.add(bullet);
    }

    // remove bullets outside of the canvas
    void removeFailedBullets(int maxHeight) {
        _bullets.removeWhere((final Bullet bullet) {
            return bullet.y > maxHeight;
        });
    }

    void fire({ final int speed: 10}) {
        _bullets.forEach((final Bullet bullet) => bullet.moveUp(speed: speed));
    }

    void draw(final Painter painter) {
        painter.save();
        _bullets.forEach((final Bullet bullet) => bullet.draw(painter));
        painter.restore();
    }

    void checkIfAlienIsHit(final UnmodifiableListView<Alien> aliens) {
        aliens.where((final Alien alien) => !alien.killed).forEach((final Alien alien) {
            final math.Rectangle rectAlien = new math.Rectangle(alien.x,alien.y,alien.width,alien.height);

            for(int index = 0;index < _bullets.length;index++) {
                final Bullet bullet = _bullets[index];
                final math.Rectangle rectBullet = new math.Rectangle(bullet.x,bullet.y,bullet.width,bullet.height);
                if(rectAlien.intersects(rectBullet)) {
                    alien.killed = true;
                    _bullets.remove(bullet);
                    break;
                }
            };
        });
    }

    void checkIfCityIsHit(final Cities cities) {
        for(int index = 0;index < _bullets.length;index++) {
            final Bullet bullet = _bullets[index];
            if(cities.isCityHit(bullet)) {
                _bullets.remove(bullet);
                break;
            }
        }
    }
}

class KeyCode {
    final int code;
    const KeyCode(this.code);

    static const KeyCode Left = const KeyCode(37);
    static const KeyCode Right = const KeyCode(39);

    static const KeyCode Up = const KeyCode(38);
    static const KeyCode Down = const KeyCode(40);

    static const KeyCode Space = const KeyCode(32);
}

class InputHandler {
    final Logger _logger = new Logger('spaceinvaders.Sprites');

    final Map<int,bool> _down = new Map<int,bool>();
    final Map<int,bool> _pressed = new Map<int,bool>();

    void create() {
        dom.document.onKeyDown.listen((final dom.KeyboardEvent event) {
            _down[event.keyCode] = true;
            _pressed[event.keyCode] = true;

             //_logger.info("K ${event.keyCode}");
        });
        dom.document.onKeyUp.listen((final dom.KeyboardEvent event) {
            _down[event.keyCode] = false;
            _pressed[event.keyCode] = false;
        });
    }

    /// Always returns the current [KeyCode] status
    bool isDown(final KeyCode key) {
        return _down.containsKey(key.code) && _down[key.code];
    }

    /// Forces the user to press and release this [KeyCode] for example the
    /// space bare for firing
    bool isPressed(final KeyCode key) {
        if(_pressed.containsKey(key.code)) {
            final bool status = _pressed[key.code];
            _pressed[key.code] = false;

            return status;
        }
        return false;
    }
}

enum Direction { Left, Right }

class FrameHandler {
    int _frames = 0;
    int _frequency = 30;
    Direction _direction = Direction.Right;

    void update(void updater(final Direction direction)) {
        _frames++;
        if(_frames % _frequency == 0) {
            updater(_direction);
        }
    }

    void set updateFrequency(final int frequency) {
        _frequency = math.max(1,frequency);
    }

    int get updateFrequency => _frequency;

    void toggleDirection() { _direction = _direction == Direction.Left ? Direction.Right : Direction.Left; }
}

class SpeedGenerator {
    final Logger _logger = new Logger('spaceinvaders.SpeedGenerator');
    final math.Random _random = new math.Random();

    static final SpeedGenerator _speedgenerator = new SpeedGenerator._internal();
    factory SpeedGenerator() => _speedgenerator;

    int getSpeed(final int min,final int max) {
        var speed = _random.nextInt(max - (max - min))+(max - min) + 1;
        //_logger.info("S $speed");
        return speed;
    }

    SpeedGenerator._internal();
}

void init(final FrameHandler frameHandler, final ScreenSize screensize, final SpriteFactory spritefactory) {
    frameHandler.updateFrequency = 30;

    // Start at pos 20 and at the bottom of the screen
    spritefactory.tank.x = 20;
    spritefactory.tank.y = screensize.height - spritefactory.tank.height * 2;

    spritefactory.cities.x = 20;
    spritefactory.cities.y = spritefactory.tank.y - spritefactory.cities.height * 2;
    spritefactory.cities.width = screensize.width - 40;

    spritefactory.swarm.x = 20;
    spritefactory.swarm.width = (screensize.width * 0.666).toInt();


}

void update(final FrameHandler frameHandler,final SpriteFactory spritefactory,
        final InputHandler inputHandler, final ScreenSize screensize) {

    final SpeedGenerator speed = new SpeedGenerator();
    final int tankSpeed = speed.getSpeed(2,7);

    if (inputHandler.isDown(KeyCode.Left)) {

        spritefactory.tank.moveLeft(speed: tankSpeed);
    }
    else if (inputHandler.isDown(KeyCode.Right)) {

        spritefactory.tank.moveRight(speed: tankSpeed);

    } else if(inputHandler.isDown(KeyCode.Up)) {

        spritefactory.tank.moveUp(speed: tankSpeed);

    } else if(inputHandler.isDown(KeyCode.Down)) {

        spritefactory.tank.moveDown(speed: tankSpeed);
    }

//    if(inputHandler.isPressed(KeyCode.Down)) {
//
//        spritefactory.swarm.moveDown();
//
//    } else if(inputHandler.isPressed(KeyCode.Left)) {
//
//        spritefactory.swarm.moveLeft();
//
//    } else if(inputHandler.isPressed(KeyCode.Right)) {
//
//        spritefactory.swarm.moveRight();
//
//    }

    if(inputHandler.isPressed(KeyCode.Space)) {
        final Bullet bullet = spritefactory.bullet;
        bullet.x = spritefactory.tank.x + spritefactory.tank.width ~/ 2;
        bullet.y = spritefactory.tank.y;
        spritefactory.magazin.addBullet(bullet);
    }

    void _changeDirection(final Direction direction) {
        // spritefactory.swarm.moveDown();
        frameHandler.toggleDirection();

        // Make sure we move straight down! (undo the previous horizontal movement)
        direction == Direction.Right ? spritefactory.swarm.moveLeft() : spritefactory.swarm.moveRight();

        // frameHandler.updateFrequency = frameHandler.updateFrequency - 1;
    }

    // Moves the sprites down (toggle)
    frameHandler.update((final Direction direction) {
        spritefactory.swarm.toggle();
        direction == Direction.Left ? spritefactory.swarm.moveLeft() : spritefactory.swarm.moveRight();

        if(spritefactory.swarm.x + spritefactory.swarm.width >= (500 - 10)) {
            _changeDirection(direction);
        } else if(spritefactory.swarm.x <= 10) {
            _changeDirection(direction);
        }
    });

    spritefactory.magazin.checkIfCityIsHit(spritefactory.cities);

    spritefactory.magazin.fire(speed: speed.getSpeed(2,7));
    spritefactory.magazin.checkIfAlienIsHit(spritefactory.swarm.aliens);
    spritefactory.magazin.removeFailedBullets(screensize.height);
}

void render(final Screen screen,final SpriteFactory spritefactory) {
    screen.clear();

    final Painter painter = screen.painter;

    spritefactory.tank.draw(painter);
    spritefactory.swarm.draw(painter);

    spritefactory.cities.draw(painter);

    spritefactory.magazin.draw(painter);
}

main() {
    final Logger _logger = new Logger('spaceinvaders.main');

    configLogging();

    final InputHandler inputHandler = new InputHandler()..create();
    final FrameHandler frameHandler = new FrameHandler();
    final Screen screen = new Screen()..create();
    final SpriteFactory spritefactory = new SpriteFactory()..create();
    final ScreenSize screensize = screen.size;

    init(frameHandler,screensize,spritefactory);

    void loop() {

        update(frameHandler,spritefactory,inputHandler,screensize);
        render(screen,spritefactory);

        dom.window.requestAnimationFrame((_) => loop());
    }

    loop();
}

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}



library spaceinvaders;

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
}

class Screen {
    final Logger _logger = new Logger('spaceinvaders.Screen');

    final int _width;
    final int _height;

    dom.CanvasElement _canvas;
    dom.CanvasRenderingContext2D _context;
    Painter _painter;

    Screen({final int width: 500, final int height: 600})
        : _width = width,
            _height = height {
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

    void clear() {
        _context.clearRect(0,0,width,height);
    }

    Painter get painter => (_painter ?? (_painter = new Painter(_context)));
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

    final List<City> _cities = new List<City>();

    final List<Alien> aliens = new List<Alien>();

    Tank _tank;
    Swarm _swarm;

    void create() {
        if (_alienSprites.isEmpty) {

            _alienSprites.add(new ToggleSprite(new Sprite(_image,0, 0, 22, 16),new Sprite(_image,0, 16, 22, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,22, 0, 16, 16),new Sprite(_image,22, 16, 16, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,38, 0, 24, 16),new Sprite(_image,38, 16, 24, 16)));
        }
    }

    Tank get tank => _tank ?? (_tank = new Tank(new Sprite(_image, 62, 0, 22, 16)));

    List<City> get cities {
        if(_cities.isEmpty) {
            [1,2,3].forEach((_) {
                _cities.add(new City(new Sprite(_image,84, 8, 36, 24)));
            });
        }
        return _cities;
    }

    Swarm get swarm => _swarm ?? ( _swarm = new Swarm(_aliens));

    // - private ----------------------------------------------------------------------------------

    List<Alien> get _aliens {

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

    Alien(this._toggleSprite) {
        _logger.info("Alien created!");
    }

    @override
    Sprite get sprite => _toggleSprite;

    void toggle() { _toggleSprite.toggle(); }
}

class Swarm extends ScreenObject implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Swarm');

    static const int ROWS = 5;
    static const int COLS = 10;

    int _x = 0;
    int _y = 0;

    final List<Alien> _aliens;

    int _width = 0;
    int _height = 0;

    Swarm(this._aliens) {
        _logger.info("Swarm created!");
        _updatePosition();
    }

    @override
    Sprite get sprite => throw new UnsupportedError("Sprite is not supported for Swarm!");

    @override
    void draw(final Painter painter) {
        _aliens.forEach((final Alien alien) => alien.draw(painter));
    }

    void toggle() { _aliens.forEach( (final Alien alien) => alien.toggle() ); }

    int get x => _x;
    int get y => _y;

    int get moveWidth => _aliens.first.width;

    void set x(final int value) {
        _x = value;
        _updatePosition();
    }

    void set y(final int value) {
        _y = value;
        _updatePosition();
    }

    void moveDown() {
        _y += _aliens.first.height;
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

        _height = ((_aliens.first.height * 1.5) * Swarm.ROWS).toInt();

        int index = 0;
        final int sectionWidth = (width ~/ Swarm.COLS);

        for(int rows = 0;rows < Swarm.ROWS;rows++) {
            for(int cols = 0; cols < Swarm.COLS; cols++) {

                final Alien alien = _aliens[index];
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

class KeyCode {
    final int code;
    const KeyCode(this.code);

    static const KeyCode Left = const KeyCode(37);
    static const KeyCode Right = const KeyCode(39);

    static const KeyCode Up = const KeyCode(38);
    static const KeyCode Down = const KeyCode(40);
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

void init(final FrameHandler frameHandler, final Screen screen, final SpriteFactory spritefactory) {
    frameHandler.updateFrequency = 30;

    spritefactory.tank.x = 20;
    spritefactory.tank.y = screen.height - spritefactory.tank.height * 2;

    final int section = (screen.width - 40) ~/ spritefactory.cities.length;
    for(int cityIndex = 0;cityIndex < spritefactory.cities.length;cityIndex++) {

        spritefactory.cities[cityIndex].x = (section * (cityIndex + 1)) - (section ~/ 2);
        spritefactory.cities[cityIndex].y = spritefactory.tank.y - spritefactory.cities[cityIndex].height * 2;

    }

    spritefactory.swarm.x = 20;
    spritefactory.swarm.width = (screen.width * 0.666).toInt();
}

void update(final FrameHandler frameHandler,final SpriteFactory spritefactory, final InputHandler inputHandler) {
    final int tankSpeed = 8;

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

    if(inputHandler.isPressed(KeyCode.Down)) {

        spritefactory.swarm.moveDown();

    } else if(inputHandler.isPressed(KeyCode.Left)) {

        spritefactory.swarm.moveLeft();

    } else if(inputHandler.isPressed(KeyCode.Right)) {

        spritefactory.swarm.moveRight();

    }

    spritefactory.cities.forEach((final City city) {

    });

    void _changeDirection() {
        spritefactory.swarm.moveDown();
        frameHandler.toggleDirection();
        //frameHandler.updateFrequency = frameHandler.updateFrequency - 1;
    }

    frameHandler.update((final Direction direction) {
        spritefactory.swarm.toggle();
        direction == Direction.Left ? spritefactory.swarm.moveLeft() : spritefactory.swarm.moveRight();

        if(spritefactory.swarm.x + spritefactory.swarm.width >= (500 - 40)) {

            _changeDirection();

        } else if(spritefactory.swarm.x <= 20) {

            _changeDirection();

        }
    });
}

void render(final Screen screen,final SpriteFactory spritefactory) {
    screen.clear();

    final Painter painter = screen.painter;

    spritefactory.tank.draw(painter);
    spritefactory.swarm.draw(painter);

    spritefactory.cities.forEach((final City city) {
        city.draw(painter);
    });

    //spritefactory.swarm._aliens.first.draw(painter);

}

main() {
    final Logger _logger = new Logger('spaceinvaders.main');

    configLogging();

    final InputHandler inputHandler = new InputHandler()..create();
    final FrameHandler frameHandler = new FrameHandler();
    final Screen screen = new Screen()..create();
    final SpriteFactory spritefactory = new SpriteFactory()..create();

    init(frameHandler,screen,spritefactory);

    void loop() {

        update(frameHandler,spritefactory,inputHandler);
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



library spaceinvaders;

import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:logging/logging.dart';

final Logger _logger = new Logger('layout-header-drawer-footer');

class Screen {
    final Logger _logger = new Logger('spaceinvaders.Screen');

    final int _width;
    final int _height;

    dom.CanvasElement _canvas;
    dom.CanvasRenderingContext2D _context;

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

class Sprite {
    final dom.ImageElement _image;
    final int _x, _y, _width, _height;
    const Sprite(this._image, this._x, this._y, this._width, this._height);
}

class ToggleSprite implements Sprite {
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

    final List<Alien> _aliens = new List<Alien>();
    final List<City> _cities = new List<City>();
    Tank _tank;

    void create() {
        if (_alienSprites.isEmpty) {

            _alienSprites.add(new ToggleSprite(new Sprite(_image,0, 0, 22, 16),new Sprite(_image,0, 16, 22, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,22, 0, 16, 16),new Sprite(_image,22, 16, 16, 16)));
            _alienSprites.add(new ToggleSprite(new Sprite(_image,38, 0, 24, 16),new Sprite(_image,38, 16, 24, 16)));
        }
    }

    Tank get tank => _tank ?? (_tank = new Tank(new Sprite(_image, 62, 0, 22, 16)));
    List<City> get cityies {
        if(_cities.isEmpty) {
            [1,2,3].forEach((_) {
                _cities.add(new City(new Sprite(_image,84, 8, 36, 24)));
            });
        }
        return _cities;
    }

    List<Alien> get aliens {
        if(_aliens.isEmpty) {
            _aliens.add(new Alien(_alienSprites.first));
        }
        return _aliens;
    }
}

abstract class Drawable {
    Sprite get sprite;
    int get x;
    int get y;
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

class Tank extends Object with MoveHorizontale,MoveVertical implements Drawable {
    final Logger _logger = new Logger('spaceinvaders.Tank');

    final Sprite _sprite;

    Tank(this._sprite) {
        _logger.info("Tank created!");
    }

    @override
    Sprite get sprite => _sprite;

    int get width => _sprite._width;
    int get height => _sprite._height;
}

class Alien implements Drawable {
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

class City implements Drawable {
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

            _logger.info("K ${event.keyCode}");
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

class FrameHandler {
    int _frames = 0;
    int _frequency = 30;

    void update(void updater()) {
        _frames++;
        if(_frames % _frequency == 0) {
            updater();
        }
    }

    void set updateFrequency(final int frequency) {
        _frequency = math.max(1,frequency);
    }

    int get updateFrequency => _frequency;
}

void init(final FrameHandler frameHandler, final Screen screen, final SpriteFactory spritefactory) {
    frameHandler.updateFrequency = 40;

    spritefactory.tank.x = 20;
    spritefactory.tank.y = screen.height - spritefactory.tank.height * 2;

    final int section = (screen.width - 40) ~/ spritefactory.cityies.length;
    for(int cityIndex = 0;cityIndex < spritefactory.cityies.length;cityIndex++) {

        spritefactory.cityies[cityIndex].x = (section * (cityIndex + 1)) - (section ~/ 2);
        spritefactory.cityies[cityIndex].y = spritefactory.tank.y - spritefactory.cityies[cityIndex].height * 2;

    }
}

void update(final FrameHandler frameHandler,final SpriteFactory spritefactory, final InputHandler inputHandler) {

    if (inputHandler.isDown(KeyCode.Left)) {

        spritefactory.tank.moveLeft(speed: 10);
    }
    else if (inputHandler.isDown(KeyCode.Right)) {

        spritefactory.tank.moveRight(speed: 10);

    } else if(inputHandler.isDown(KeyCode.Up)) {

        spritefactory.tank.moveUp(speed: 10);

    } else if(inputHandler.isDown(KeyCode.Down)) {

        spritefactory.tank.moveDown(speed: 10);

    }

    spritefactory.cityies.forEach((final City city) {

    });


    frameHandler.update(() {
        spritefactory.aliens.first.toggle();
    });
}

void render(final Screen screen,final SpriteFactory spritefactory) {
    screen.clear();

    screen.draw(spritefactory.tank);
    screen.draw(spritefactory.aliens.first);

    spritefactory.cityies.forEach((final City city) {
        screen.draw(city);
    });
}

main() {
    final Logger _logger = new Logger('spaceinvaders.main');

    configLogging();

    final InputHandler inputHandler = new InputHandler()..create();
    final FrameHandler frameHandler = new FrameHandler();
    final Screen screen = new Screen()..create();
    final SpriteFactory spritefacory = new SpriteFactory()..create();

    init(frameHandler,screen,spritefacory);

    void loop() {

        update(frameHandler,spritefacory,inputHandler);
        render(screen,spritefacory);

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



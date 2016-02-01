library spaceinvaders.app;

import 'dart:collection';
import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;
import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:mdl/mdl.dart';

import 'package:spaceinvaders/components/interface/actions.dart';
import 'package:spaceinvaders/components/interface/stores.dart';

import 'package:spaceinvaders/spaceinvaders.dart';
import 'package:spaceinvaders/components.dart';
import 'package:spaceinvaders/stores.dart';
import 'package:spaceinvaders/gamestate.dart';

part 'app/config.dart';

part 'app/init.dart';
part 'app/update.dart';
part 'app/render.dart';

GameState checkGameState(final SpriteFactory spritefactory) {
    if(spritefactory.swarm.aliensAlive().length == 0) {
        return GameState.YouWon;
    }

    if(spritefactory.tank.hits >= 3) {
        return GameState.YouLost;
    }

    if(spritefactory.swarm.closestAlien().collidesWith(spritefactory.cities)) {
        return GameState.YouLost;
    }

    return GameState.Continue;
}

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('spaceinvaders.Application');

    final SpaceInvadersStore _store;

    final FrameHandler _frameHandler = new FrameHandler();
    final SpriteFactory _spritefactory = new SpriteFactory();
    final Screen _screen = new Screen();

    Application(this._store) {
        Validate.notNull(_store);
    }

    void run() {
        final InputHandler inputHandler = new InputHandler()..create();

        _screen.create();
        _spritefactory.create();

        final ScreenSize screensize = _screen.size;

        _bindActions();

        init(_frameHandler,screensize,_spritefactory);

        void _gameLoop() {

            if(_store.hasStarted) {
                update(_frameHandler,_spritefactory,inputHandler,screensize);
                render(_screen,_spritefactory);
            }

            final GameState state = checkGameState(_spritefactory);
            if(state != _store.gamestate) {
                _store.fire(new GameStateAction(state));
            }

            // AnimationFrame becomes our main-loop
            dom.window.requestAnimationFrame( (_) => _gameLoop());
        }

        _gameLoop();
    }

    // - private -------------------------------------------------------------------------------------------------------

    void _bindActions() {
        _store.onChange.listen( (_) {
            if(_store.hasStarted == true) {
                init(_frameHandler,_screen.size,_spritefactory);
            }
        });
    }
}

main() async {
    // final Logger _logger = new Logger('spaceinvaders.app.main');

    configLogging();
    registerMdl();
    registerSpaceInvaderComponents();

    final Application app = await componentFactory().rootContext(Application).addModule(
        new SpaceInvadersModule()).run();

    app.run();
}

/**
 * SI Module
 */
class SpaceInvadersModule extends di.Module {
    SpaceInvadersModule() {
        // install(new XXXModule());

        // -- services

        // -- stores
        bind(SpaceInvadersStore, toImplementation: SpaceInvadersStoreImpl);
    }
}

void configLogger() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}



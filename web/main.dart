library spaceinvaders.app;

import 'dart:async';
import 'dart:collection';
import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_flux/m4d_flux.dart';
import 'package:m4d_animation/m4d_animation.dart';

import 'package:spaceinvaders/spaceinvaders.dart';
import 'package:spaceinvaders/services.dart' as siService;
import 'package:m4d_core/services.dart' as coreService;

part 'app/init.dart';
part 'app/update.dart';
part 'app/render.dart';

final MdlAnimation bounceIn = new MdlAnimation.fromStock(
    StockAnimation.BounceInBottom.change(duration: new Duration(milliseconds: 800)));

final MdlAnimation fadeOut = new MdlAnimation.fromStock(StockAnimation.FadeOut);

final MdlAnimation flushRight = new MdlAnimation.fromStock(StockAnimation.FlushRight);

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

class Application extends MaterialApplication {
    final Logger _logger = new Logger('spaceinvaders.Application');

    final SpaceInvadersStore _store;
    final _actionbus = ActionBus();

    final FrameHandler _frameHandler = new FrameHandler();
    final SpriteFactory _spritefactory = new SpriteFactory();
    final Screen _screen = new Screen();

    Application() : _store = siService.SpaceInvadersStore.resolve();

    void run() {
        final InputHandler inputHandler = new InputHandler()..create();

        _screen.create();
        _spritefactory.create();

        final ScreenSize screensize = _screen.size;

        _bindActions();

        init(_frameHandler,screensize,_spritefactory);
        int prevTankHits = 0;

        void _gameLoop() {

            if(_store.hasStarted) {
                update(_frameHandler,_spritefactory,inputHandler,screensize);
                render(_screen,_spritefactory);
            }

            final GameState state = checkGameState(_spritefactory);
            if(state != _store.gamestate) {
                if(state != GameState.Continue) {
                    prevTankHits = 0;
                }
                _store.fire(new GameStateAction(state));
            }
            if(prevTankHits != _spritefactory.tank.hits) {
                prevTankHits = _spritefactory.tank.hits;
                _store.fire(new TankHitAction(_spritefactory.tank.hits));
            }

            // AnimationFrame becomes our main-loop
            dom.window.requestAnimationFrame( (_) => _gameLoop());
        }

        _gameLoop();

        bounceIn(dom.querySelector(".title"),persist: true).then((_) {
            new Future.delayed(new Duration(milliseconds: 1200),() {
                flushRight(dom.querySelector(".title"),persist: true).then((_) {
                    dom.querySelector(".game-container").classes.add("ready");
                    _logger.info("Animation completed!");
                });
            });
        });
    }

    // - private -------------------------------------------------------------------------------------------------------

    void _bindActions() {
        _actionbus.on(StartGameAction.NAME).listen( (_) {
            if(_store.hasStarted == true) {
                init(_frameHandler,_screen.size,_spritefactory);
            }
        });
    }
}

main() async {
    // final Logger _logger = new Logger('spaceinvaders.app.main');

    configLogging(show: Level.INFO);

    // Initialize M4D
    ioc.Container.bindModules([
        SpaceInvaderModule()
    ]).bind(coreService.Application).to(Application());;

    final app = await componentHandler().upgrade<Application>();
    app.run();
}



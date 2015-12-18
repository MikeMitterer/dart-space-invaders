library spaceinvaders.app;

import 'dart:collection';
import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:console_log_handler/console_log_handler.dart';
import 'package:logging/logging.dart';

import 'package:spaceinvaders/spaceinvaders.dart';

part 'app/config.dart';

part 'app/init.dart';
part 'app/update.dart';
part 'app/render.dart';

main() {
    final Logger _logger = new Logger('spaceinvaders.app.main');

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

        switch(checkGameState(spritefactory)) {
            case GameState.YouWon:
                _logger.info("You won!!!!!!");
                return;

            case GameState.YouLost:
                _logger.info("You lost - sorry!");
                return;

            case GameState.Continue:
            default:
                break;
        }

        // AnimationFrame becomes our main-loop
        dom.window.requestAnimationFrame((_) => loop());
    }

    loop();
}

enum GameState {  Continue, YouLost, YouWon }

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




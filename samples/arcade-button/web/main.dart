import "dart:html" as dom;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';

import 'package:spaceinvaders/components/interface/stores.dart';

import 'package:spaceinvaders/components.dart';
import 'package:spaceinvaders/stores.dart';

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        final ArcadeButtonComponent button = ArcadeButtonComponent.widget(dom.querySelector("mdlx-arcade-button"));
        button.onClick.listen((_) {
            _logger.info("Clicked!");
        });
    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    // final Logger _logger = new Logger('main.Arcade-Button');

    configLogging();

    registerMdl();
    registerSpaceInvaderComponents();

    final Application app = await componentFactory().rootContext(Application).addModule(
        new SpaceInvadersModule()).run(enableVisualDebugging: true);

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

void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
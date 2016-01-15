import "dart:html" as dom;
import "dart:async";
import "dart:math" as Math;

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';
import 'package:di/di.dart' as di;

import 'package:mdl/mdl.dart';
import 'package:mdl/mdlobservable.dart';

import 'package:spaceinvaders/components.dart';

@MdlComponentModel @di.Injectable()
class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        final ArcadeButtonComponent button = ArcadeButtonComponent.widget(dom.querySelector(".mdlx-arcade-button"));
        button.onClick.listen((_) {
            _logger.info("Clicked!");
        });
    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    final Logger _logger = new Logger('main.Arcade-Button');

    configLogging();

    registerMdl();
    registerSpaceInvaderComponents();

    final MaterialApplication application = await componentFactory().
        rootContext(Application).run(enableVisualDebugging: true);

    application.run();
}


void configLogging() {
    hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}
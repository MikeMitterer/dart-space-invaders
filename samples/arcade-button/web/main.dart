import "dart:html" as dom;

import 'package:console_log_handler/console_log_handler.dart';

import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_core/services.dart' as coreService;

import 'package:spaceinvaders/spaceinvaders.dart';

class Application extends MaterialApplication {
    final Logger _logger = new Logger('main.Application');

    Application() {
    }

    @override
    void run() {
        Future(() {
            final button = ArcadeButtonComponent.widget(dom.querySelector("mdlx-arcade-button"));

            button.onClick.listen((_) {
                _logger.info("Clicked!");
            });
        });
    }

    //- private -----------------------------------------------------------------------------------

}

main() async {
    // final Logger _logger = new Logger('main.Arcade-Button');

    configLogging(show: Level.INFO);

    // Initialize M4D
    ioc.Container.bindModules([
        SpaceInvaderModule()
    ]).bind(coreService.Application).to(Application());;

    final app = await componentHandler().upgrade<Application>();
    app.run();
}


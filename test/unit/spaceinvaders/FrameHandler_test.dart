@TestOn("content-shell")
import 'package:test/test.dart';

// import 'package:logging/logging.dart';

import '../config.dart';
import 'package:spaceinvaders/spaceinvaders.dart';

main() async {
    // final Logger _logger = new Logger("test.FrameHandler");
    
    configLogging();

    group('FrameHandler', () {
        setUp(() { });

        test('> updateFrequency', () {
            final FrameHandler fh = new FrameHandler();

            fh.updateFrequency = 10;

            // frequency is 10 so onUpdate should be called twice
            final Function onUpdate = expectAsync((final Direction direction) {

            },count: 2);

            for(int counter = 0;counter < 25;counter++) {
                fh.update( onUpdate);
            }

        }); // end of 'updateFrequency' test


    });
    // End of 'FrameHandler' group
}

// - Helper --------------------------------------------------------------------------------------

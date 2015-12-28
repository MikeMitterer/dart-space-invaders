@TestOn("content-shell")
import 'package:test/test.dart';

// import 'package:logging/logging.dart';

import '../config.dart';
import 'package:spaceinvaders/spaceinvaders.dart';

main() async {
    // final Logger _logger = new Logger("test.SpeedGenerator");
    
    configLogging();


    group('SpeedGenerator', () {
        setUp(() { });

        test('> getSpeed', () {

            final SpeedGenerator speedGenerator = new SpeedGenerator();
            for(int counter = 0;counter < 50; counter++) {
                expect(speedGenerator.getSpeed(10,20),inInclusiveRange(10,20));
            }

        }); // end of 'getSpeed' test

    });
    // End of 'SpeedGenerator' group
}

// - Helper --------------------------------------------------------------------------------------

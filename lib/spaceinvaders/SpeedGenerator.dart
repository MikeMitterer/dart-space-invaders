/*
 * Copyright (c) 2015, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
     
part of spaceinvaders;

/// Implemented as Singleton - makes it easy (+ cheap) to create this
/// object on every update iteration
class SpeedGenerator {
    final Logger _logger = new Logger('spaceinvaders.SpeedGenerator');
    final math.Random _random = new math.Random();

    static final SpeedGenerator _speedgenerator = new SpeedGenerator._internal();
    factory SpeedGenerator() => _speedgenerator;

    int getSpeed(final int min,final int max) {
        var speed = _random.nextInt(max - (max - min))+(max - min) + 1;
        //_logger.info("S $speed");
        return speed;
    }

    SpeedGenerator._internal();
}

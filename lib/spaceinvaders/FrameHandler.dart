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

enum Direction { Left, Right }

class FrameHandler {
    int _frames = 0;
    int _frequency = 30;
    Direction _direction = Direction.Right;

    void update(void updater(final Direction direction)) {
        _frames++;
        if(_frames % _frequency == 0) {
            updater(_direction);
        }
    }

    void set updateFrequency(final int frequency) {
        _frequency = math.max(1,frequency);
    }

    int get updateFrequency => _frequency;

    void toggleDirection() { _direction = _direction == Direction.Left ? Direction.Right : Direction.Left; }
}
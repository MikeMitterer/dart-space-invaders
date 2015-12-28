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

/// Abstraction for keycodes typed by the user
class KeyCode {
    final int code;
    const KeyCode(this.code);

    static const KeyCode Left = const KeyCode(37);
    static const KeyCode Right = const KeyCode(39);

    static const KeyCode Up = const KeyCode(38);
    static const KeyCode Down = const KeyCode(40);

    static const KeyCode Space = const KeyCode(32);
}

/// Listens for key pressed
class InputHandler {
    final Logger _logger = new Logger('spaceinvaders.Sprites');

    final Map<int,bool> _down = new Map<int,bool>();
    final Map<int,bool> _pressed = new Map<int,bool>();

    void create() {
        dom.document.onKeyDown.listen((final dom.KeyboardEvent event) {
            _down[event.keyCode] = true;
            _pressed[event.keyCode] = true;

            //_logger.info("K ${event.keyCode}");
        });
        dom.document.onKeyUp.listen((final dom.KeyboardEvent event) {
            _down[event.keyCode] = false;
            _pressed[event.keyCode] = false;
        });
    }

    /// Always returns the current [KeyCode] status
    bool isDown(final KeyCode key) {
        return _down.containsKey(key.code) && _down[key.code];
    }

    /// Forces the user to press and release this [KeyCode] for example the
    /// space bare for firing
    bool isPressed(final KeyCode key) {
        if(_pressed.containsKey(key.code)) {
            final bool status = _pressed[key.code];
            _pressed[key.code] = false;

            return status;
        }
        return false;
    }
}

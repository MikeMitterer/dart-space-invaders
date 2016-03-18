/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
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
     
part of spaceinvaders.stores;

@di.Injectable()
class SpaceInvadersStoreImpl extends Dispatcher implements SpaceInvadersStore {
    final Logger _logger = new Logger('spaceinvaders.stores.SpaceInvaderStoreImpl');

    bool _hasStarted = false;
    GameState _gamestate = GameState.Idle;
    int _tanksLost = 0;

    SpaceInvadersStoreImpl(final ActionBus actionbus)
        : super(actionbus)  {
        Validate.notNull(actionbus);

        _bindActions();
    }

    /// Indicator if game runs or has stopped
    bool get hasStarted => _hasStarted;

    /// Game-Status
    GameState get gamestate => _gamestate;

    int get tanksLost => _tanksLost;

    //- private -----------------------------------------------------------------------------------

    void _bindActions() {
        on(StartGameAction.NAME).listen((_) {
            _hasStarted = !_hasStarted;

            _logger.info("Start Game - Status: ${hasStarted ? 'started' : 'stopped'}");
            emitChange();
        });

        on(GameStateAction.NAME).listen(( final GameStateAction action) {
            _gamestate = action.data;
            switch(_gamestate) {
                case GameState.YouWon:
                    _logger.info("You won!!!!!!");
                    _hasStarted = false;
                    return;

                case GameState.YouLost:
                    _logger.info("You lost - sorry!");
                    _hasStarted = false;
                    return;

                case GameState.Continue:
                case GameState.Idle:
                default:
                    break;
            }
            emitChange();
        });

        on(TankHitAction.NAME).listen((final TankHitAction action) {
            _tanksLost = action.data;

            _logger.info("Tanks lost: ${_tanksLost}");
            emitChange();
        });
    }
}

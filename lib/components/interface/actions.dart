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

/// All [Action]s used for this application
library spaceinvaders.components.actions;

import 'package:m4d_flux/m4d_flux.dart';
import 'package:validate/validate.dart';

import 'package:spaceinvaders/gamestate.dart';

/// User clicks on Arcade-Button
class StartGameAction extends Action {
    static const ActionName NAME = const ActionName("spaceinvaders.components.actions.StartGameAction");
    StartGameAction() : super(ActionType.Signal,NAME);
}

/// Game-State changes
class GameStateAction extends DataAction<GameState> {
    static const ActionName NAME = const ActionName("spaceinvaders.components.actions.GameStateAction");
    GameStateAction(final GameState state) : super(NAME,state) { Validate.notNull(state); }
}

/// We lost a tank
class TankHitAction extends DataAction<int> {
    static const ActionName NAME = const ActionName("spaceinvaders.components.actions.TankHitAction");
    TankHitAction(final int hits) : super(NAME,hits);
}

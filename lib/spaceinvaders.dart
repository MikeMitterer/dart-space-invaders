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

/// The classic Space Invaders game written in Dart.
library spaceinvaders;

import 'dart:collection';
import 'dart:html' as dom;
import 'dart:math' as math;

import 'package:logging/logging.dart';

import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_components/m4d_components.dart';

import 'components.dart';
import 'services.dart' as siService;
import 'store.dart';

export 'components.dart';
export 'components/interface/store.dart';
export 'components/interface/actions.dart';
export 'gamestate.dart';

part 'spaceinvaders/drawables.dart';
part 'spaceinvaders/painter.dart';
part 'spaceinvaders/screen.dart';
part 'spaceinvaders/sprite.dart';

part 'spaceinvaders/FrameHandler.dart';
part 'spaceinvaders/InputHandler.dart';
part 'spaceinvaders/Magazin.dart';
part 'spaceinvaders/SpeedGenerator.dart';
part 'spaceinvaders/SpriteFactory.dart';

class SpaceInvaderModule extends ioc.Module {
    @override
    configure() {
        registerSpaceInvaderComponents();

        ioc.Container().bind(siService.SpaceInvadersStore).to(SpaceInvadersStoreImpl());
    }

    @override
    List<ioc.Module> get dependsOn => [
        CoreComponentsModule()
    ];
}










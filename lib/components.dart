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
     
library spaceinvaders.components;

import 'dart:html' as dom;


import 'package:logging/logging.dart';

import 'package:m4d_core/m4d_core.dart';
import 'package:m4d_core/m4d_ioc.dart' as ioc;
import 'package:m4d_flux/m4d_flux.dart';
import 'package:m4d_components/m4d_components.dart';

import 'package:spaceinvaders/services.dart' as siService;

import 'package:spaceinvaders/components/interface/store.dart';
import 'package:spaceinvaders/components/interface/actions.dart';
import 'package:spaceinvaders/gamestate.dart';

part 'components/ArcadeButtonComponent.dart';
part 'components/ButtonLabelComponent.dart';
part 'components/StatusBarComponent.dart';
part 'components/StatusMessageComponent.dart';

void registerSpaceInvaderComponents() {

    registerArcadeButtonComponent();
    registerButtonLabelComponent();
    registerStatusBarComponent();
    registerStatusMessageComponent();

}


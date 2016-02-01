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
     
part of spaceinvaders.app;

/// Initializes the game - means sets the initial values for [FrameHandler] and so forth.
/// Defines the base-positions for all the [Drawables] like [Tank], [Swarm]...
void init(final FrameHandler frameHandler, final ScreenSize screensize, final SpriteFactory spritefactory) {
    frameHandler.updateFrequency = 30;

    void _resetGameState() {
        spritefactory.tank.hits = 0;

        spritefactory.swarm.resuscitate();
        spritefactory.swarm.y = 0;

        spritefactory.cities.buildCycle = 0;
    }

    _resetGameState();

    // Start at pos 20 and at the bottom of the screen
    spritefactory.tank.x = 20;
    spritefactory.tank.y = screensize.height - spritefactory.tank.height * 2;


    spritefactory.cities.y = spritefactory.tank.y - spritefactory.cities.height * 2;
    spritefactory.cities.width = screensize.width - 40;

    spritefactory.swarm.x = 20;
    spritefactory.swarm.width = (screensize.width * 0.666).toInt();


}

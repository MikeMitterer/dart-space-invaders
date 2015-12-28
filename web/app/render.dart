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

/// Draws all the [Drawables]. [Screen] returns a [Painter] that is used for
/// all the drawing operations
void render(final Screen screen,final SpriteFactory spritefactory) {
    screen.clear();

    final Painter painter = screen.painter;

    spritefactory.tank.draw(painter);

    spritefactory.swarm.draw(painter);

    spritefactory.cities.draw(painter);

    spritefactory.magazin.draw(painter);
}
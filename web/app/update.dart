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

/// All the properties will be updatet. X/Y positions, moving the swarm,
/// firing [Bullet]s from the [Magazin]
bool update(final FrameHandler frameHandler,final SpriteFactory spritefactory,
    final InputHandler inputHandler, final ScreenSize screensize) {

    final SpeedGenerator speed = new SpeedGenerator();
    final int tankSpeed = speed.getSpeed(2,7);

    final bool swarmAutoMove = true;

    // Only for debugging
    final bool tankCanMoveVertically = false;

    // Only for debugging
    final bool swarmCanMoveUpAndDown = true && !tankCanMoveVertically;

    final Tank tank = spritefactory.tank;
    if (inputHandler.isDown(KeyCode.Left)) {

        tank.moveLeft(speed: tankSpeed);
    }
    else if (inputHandler.isDown(KeyCode.Right)) {

        tank.moveRight(speed: tankSpeed);

    } else if(inputHandler.isDown(KeyCode.Up) && tankCanMoveVertically) {

        tank.moveUp(speed: tankSpeed);

    } else if(inputHandler.isDown(KeyCode.Down) && tankCanMoveVertically) {

        tank.moveDown(speed: tankSpeed);
    }
    tank.x = math.min(math.max(tank.x,0),screensize.width - tank.width);
    tank.y = math.min(math.max(tank.y,0),screensize.height - tank.height);

    if(inputHandler.isPressed(KeyCode.Up) && swarmCanMoveUpAndDown) {

        spritefactory.swarm.moveUp();

    } else if(inputHandler.isPressed(KeyCode.Down) && swarmCanMoveUpAndDown) {

        spritefactory.swarm.moveDown();

    }

    if(inputHandler.isPressed(KeyCode.Space)) {
        final Bullet bullet = spritefactory.bullet;
        bullet.x = spritefactory.tank.x + spritefactory.tank.width ~/ 2;
        bullet.y = spritefactory.tank.y - (bullet.height * 1.1).toInt();
        bullet.velocity = speed.getSpeed(2,8);
        spritefactory.magazin.addBullet(bullet);
    }

    void _chooseAlienToFire() {
        final UnmodifiableListView<Alien> aliensInFront = spritefactory.swarm.getFrontAliens();
        final math.Random _random = new math.Random();

        if(aliensInFront.length == 0) {
            return;
        }
        int randomAlien = 0;
        if(aliensInFront.length > 1) {
            randomAlien = _random.nextInt(aliensInFront.length);
        }
        final Alien alien = aliensInFront[randomAlien];
        final Bullet bullet = spritefactory.bullet;
        bullet.x = alien.x + alien.width ~/ 2;
        bullet.y = alien.y + (bullet.height * 1.5).toInt();
        bullet.velocity = speed.getSpeed(2,4) * -1;
        spritefactory.magazin.addBullet(bullet);
    }

    void _changeDirection(final Direction direction) {
        if(swarmAutoMove) {
            spritefactory.swarm.moveDown();
        }
        frameHandler.toggleDirection();

        // Make sure we move straight down! (undo the previous horizontal movement)
        direction == Direction.Right ? spritefactory.swarm.moveLeft() : spritefactory.swarm.moveRight();

        if(swarmAutoMove) {
            frameHandler.updateFrequency = frameHandler.updateFrequency - 1;
        }
    }

    // Moves the sprites down (toggle)
    // The frequency is defined in "init"
    frameHandler.update((final Direction direction) {
        spritefactory.swarm.toggle();
        direction == Direction.Left ? spritefactory.swarm.moveLeft() : spritefactory.swarm.moveRight();

        if(spritefactory.swarm.x + spritefactory.swarm.width >= (500 - 10)) {
            _changeDirection(direction);
        } else if(spritefactory.swarm.x <= 10) {
            _changeDirection(direction);
        }

        _chooseAlienToFire();
    });

    spritefactory.magazin.checkIfTankIsHit(spritefactory.tank);

    // Looks more realistic if this check is before the next "fire" command
    spritefactory.magazin.checkIfCityIsHit(spritefactory.cities);

    spritefactory.magazin.fire();
    spritefactory.magazin.checkIfAlienIsHit(spritefactory.swarm.aliens);
    spritefactory.magazin.removeFailedBullets(screensize.height);

    return true;
}

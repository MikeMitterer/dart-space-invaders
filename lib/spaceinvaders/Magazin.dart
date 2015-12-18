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

class Magazin {
    final List<Bullet> _bullets = new List<Bullet>();

    void addBullet(final Bullet bullet) {
        _bullets.add(bullet);
    }

    // remove bullets outside of the canvas
    void removeFailedBullets(int maxHeight) {
        _bullets.removeWhere((final Bullet bullet) {
            return bullet.y > maxHeight || bullet.y < 0;
        });
    }

    void fire() {
        _bullets.forEach((final Bullet bullet) => bullet.move());
    }

    void draw(final Painter painter) {
        painter.save();
        _bullets.forEach((final Bullet bullet) => bullet.draw(painter));
        painter.restore();
    }

    void checkIfAlienIsHit(final UnmodifiableListView<Alien> aliens) {
        aliens.where((final Alien alien) => !alien.killed).forEach((final Alien alien) {

            final math.Rectangle rectAlien = new math.Rectangle(alien.x,alien.y,alien.width,alien.height);

            for(int index = 0;index < _bullets.length;index++) {
                final Bullet bullet = _bullets[index];
                final math.Rectangle rectBullet = new math.Rectangle(bullet.x,bullet.y,bullet.width,bullet.height);
                if(rectAlien.intersects(rectBullet)) {
                    alien.killed = true;
                    _bullets.remove(bullet);
                    break;
                }
            };
        });
    }

    void checkIfCityIsHit(final Cities cities) {
        for(int index = 0;index < _bullets.length;index++) {
            final Bullet bullet = _bullets[index];
            if(cities.isCityHit(bullet)) {
                _bullets.remove(bullet);
                break;
            }
        }
    }

    void checkIfTankIsHit(final Tank tank) {
        for(int index = 0;index < _bullets.length;index++) {
            final Bullet bullet = _bullets[index];
            if(tank.collidesWith(bullet)) {
                tank.hits++;
                _bullets.remove(bullet);
                break;
            }
        }
    }
}

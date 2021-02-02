/**


ver1`: with OSC.


based on P5 standard examples:
 * Multiple Particle Systems
 * by Daniel Shiffman.
 *
 * Click the mouse to generate a burst of particles
 * at mouse position.
 *
 * Each burst is one instance of a particle system
 * with Particles and CrazyParticles (a subclass of Particle)
 * Note use of Inheritance and Polymorphism here.
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

ArrayList<ParticleSystem> systems;
int startHue = 0;

void setup() {
  //size(640, 360);
  size(1280, 720);
  systems = new ArrayList<ParticleSystem>();
  colorMode(HSB);

  oscP5 = new OscP5(this, 55555); // receiving addr. 
  myRemoteLocation = new NetAddress("127.0.0.1", 57120); //  reply addr to SC
}

void draw() {
  background(0);
  for (ParticleSystem ps : systems) {
    ps.run();
    ps.addParticle();
  }
  if (systems.isEmpty()) {
    fill(255);
    textAlign(CENTER);
    text("click mouse to add particle systems", width/2, height/2);
  }
}

void mousePressed() {
  startHue = (startHue + int(random( random(30) ))) % 255;
  systems.add(new ParticleSystem(1, new PVector(mouseX, mouseY), startHue));
}
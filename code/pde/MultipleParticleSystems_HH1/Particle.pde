// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  int hue;

  Particle(PVector l, int myHue, float xSpread) {
    acceleration = new PVector(0, 0.05);
    //velocity = new PVector(random(random(0, direction), 0), random(-2, 0));
    velocity = new PVector(random(xSpread * -1, xSpread), random(-2, 0));
    position = l.copy();
    println("hue: " + myHue);
    hue = myHue;
    lifespan = 200.0;
  }

  void run() {
    update();
    display();
    sendOSC();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.2;
  }

  // Method to display
  void display() {
    int maHue = hue + int(random(-14,14));
    stroke(maHue, 240, 240, lifespan);
    fill(maHue, 240, 240, lifespan);
    ellipse(position.x, position.y, 8, 8);
  }

  // Method to send itself
  void sendOSC() {
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage myMessage = new OscMessage("/particle");

    myMessage.add(position.x);
    myMessage.add(position.y);
    myMessage.add(lifespan); /* add a float to the osc message */
    myMessage.add(hue); /* add a string to the osc message */
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
  }

  // Is the particle still useful?
  boolean isDead() {
    return (lifespan < 0.0);
  }
}

// An ArrayList is used to manage the list of Particles

class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin;                   // An origin point for where particles are birthed
  int pCnt = 0;
  int hue;

  ParticleSystem(int num, PVector v, int maHue) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    hue = maHue;
    origin = v.copy();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin, hue, 1.0));    // Add "num" amount of particles to the arraylist
    }
  }


  void run() {
    // Cycle through the ArrayList backwards, because we are deleting while iterating
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      if (p.isDead()) {
        particles.remove(i);
      } else { 
        p.run();
      }
    }
  }

  void addParticle() {
    if (pCnt < 100) {
      Particle p;
      p = new Particle(origin, hue, random(0.80, -5.0));
      particles.add(p);
      pCnt ++;
    }
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    return particles.isEmpty();
  }
}

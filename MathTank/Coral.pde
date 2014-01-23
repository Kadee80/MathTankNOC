class Coral {

  VerletPhysics2D physics;
  ArrayList<CParticle> particles;
  ArrayList<CSpring> springs;

  //variables for timer
  float startTime, currTime;
  float hitTime;
  float x, y;
  color greenness;
  float alpha;
  boolean isDead;

  Coral(float _x, float _y, float _r, float _g, float _b, float _a) {
    alpha = _a;
    greenness = color(_r, _g, _b, alpha);
    particles = new ArrayList<CParticle>();
    springs = new ArrayList<CSpring>();

    hitTime = random(1000, 1500); 
    startTime = millis();

    x=_x;
    y=_y;

    isDead = false;

    physics = new VerletPhysics2D();
    physics.setDrag(0.3f);
    physics.addBehavior(new GravityBehavior(new Vec2D(0, -1f)));



    //first particle in cener bottom for now
    CParticle p;
    p = new CParticle(x, y, 10, 4, 5);
    particles.add(p);
    physics.addParticle(p);
    physics.addBehavior(new AttractionBehavior(p, 200, -3.0f, 0.01f));
  }

  void grow() {
    // add a new particle every second
    currTime = millis() - startTime;
    if ( currTime >= hitTime & particles.size()<100)
    {
      startTime = millis();
      addParticle();
    }

    //dispay our system
    physics.update();
    CParticle c = particles.get(0);
    c.lock();


    for (CParticle p : particles) {
      p.display();
    }
    for (CSpring s: springs) {
      s.display();
    }

    for (int i = particles.size()-1; i>=1; i--) {
      CParticle p = particles.get(i);
      CSpring k = springs.get(i-1);
      if (p.y < 0) {
        p.isDead = true;
      }
      if (p.isDead == true) {

        springs.remove(k);
        physics.removeSpring(k);
        particles.remove(p);
        physics.removeParticle(p);
      }
    }
    
    
  }

  //logic for adding particles
  void addParticle() {
    int r;
    float len = 50;
    float radius =60;
    float thickness;
    int jointSize;
    int podSize;
    r = int(random(particles.size()));

    //control spring length particle repulsion, and a few display vairables here
    if (particles.size()< 15) {
      thickness = 4;
      jointSize = 4;
      podSize = 3;
    }
    else if ( particles.size()< 50) {
      len = 40;
      radius = 45;
      thickness = 3;
      jointSize = 3;
      podSize = 2;
    }

    else if (particles.size()< 75) {
      len = 30;
      radius = 35;
      thickness = 2;
      jointSize = 2;
      podSize = 1;
    }

    else if (particles.size()< 100) {
      len = 20;
      radius = 25;
      thickness = 1;
      jointSize = 1;
      podSize = 1;
    }

    else {
      len = 10;
      radius = 20;
      thickness = 1;
      jointSize = 1;
      podSize = 1;
    }

    //grab a previous particle to connect to
    CParticle oldP = particles.get(r);
    //check to see if the particle we are attaching to doesnt have too many connections, if it does, pick another
    int numCon = oldP.countConnections();
    if (numCon >3) {
      //println("too many connections, skipping");
      r = int(random(particles.size()-1));
      oldP = particles.get(r);
      numCon = oldP.countConnections();
    }

    else {
      //get the the average vector direction from previous connections and invert it
      Vec2D dir = oldP.getBranchDirection();
      //then add the new particle at the direction vector (from previous particle)
      CParticle newP = new CParticle(oldP.x+dir.x, oldP.y+dir.y, thickness/3, jointSize, podSize);
      particles.add(newP);
      //add repulsion
      physics.addBehavior(new AttractionBehavior(newP, radius, -2.3f, 0.01f));
      physics.addParticle(newP);
      //add the spring connection between old and new particle
      CSpring s = new CSpring(newP, oldP, len*.7, .2, thickness*.5, greenness);
      newP.addConnection(oldP);
      oldP.addConnection(newP);
      springs.add(s);
      physics.addSpring(s);
    }
  }

  //Get a particle based on coordinates, use these to detangle a messy coral
  CParticle GetParticleByCoordinate(int x, int y)
  {
    CParticle ParticleToReturn = new CParticle(0, 0, 0, 0, 0);
    for (int i = 0; i < particles.size(); i++) {
      CParticle particle = (CParticle) particles.get(i);
      if (particle.x == x && particle.y == y)
        ParticleToReturn = particle;
    }
    return ParticleToReturn;
  }
}


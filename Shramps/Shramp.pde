class Shramp {

  VerletPhysics2D physics;
  ArrayList<Particle> particles;
  ArrayList<Spring> springs;
  //variables for timer
  float startTime, currTime;
  float hitTime;
  float x, y,r;

  Shramp(float _x, float _y) {
    physics = new VerletPhysics2D();
    physics.setDrag(0.02f);
    physics.setWorldBounds(new Rect(-50, -50, width+100, height+100));
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.02)));

    r=20;
    x=_x;
    y=_y;
    hitTime = random(800, 1000); 
    startTime = millis();

    particles = new ArrayList<Particle>();
    springs = new ArrayList<Spring>();
    
    Particle p;
    p = new Particle(x, y, 5);
    p.lock();
    particles.add(p);
    physics.addBehavior(new AttractionBehavior(p, 12, -3.0f, 0.01f));
    physics.addParticle(p);

    for (int i = 1; i<8;i++) {
      Particle q;
      q = new Particle(x, y, 3);
      particles.add(q);
      physics.addBehavior(new AttractionBehavior(q, 12, -2.0f, 0.01f));
      physics.addParticle(q);
      Particle a = particles.get(i);
      Particle b = particles.get(i-1);
      Spring s = new Spring(a, b, 3, .02);
      springs.add(s);
      physics.addSpring(s);
    }


    //get the head
    Particle h = particles.get(0);
    heads.add(h);
    //give it antennae
    Particle a1 = new Particle(width/2, height/2, 2);
    Particle a2 = new Particle(width/2, height/2, 2);
    Spring as1 = new Spring(h, a1, 7, .2);
    Spring as2 = new Spring(h, a2, 7, .2);
    physics.addBehavior(new AttractionBehavior(a1, 15, -1.0f, 0.01f));
    physics.addBehavior(new AttractionBehavior(a2, 15, -1.0f, 0.01f));
    //get the tail
    Particle t = particles.get(particles.size()-1);
    //connect head and tail 
    Spring z = new Spring(h, t, 7, .001);
    //dont add the hidden spring so it doesnt display 
    //springs.add(z);
    particles.add(a1);
    particles.add(a2);
    springs.add(as1);
    springs.add(as2);
    physics.addParticle(a1);
    physics.addParticle(a2);
    physics.addSpring(z);
    physics.addSpring(as1);
    physics.addSpring(as2);
  }



  void go() {

    Particle c = particles.get(0);
    c.displayHead();

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      c.swim();
      startTime = millis();
    }

    for (Particle p : particles) {
      p.display();
    }
    
    for (Spring s: springs) {
      s.display();
    }

    physics.update();
    borders();
  }
  
    void borders() {
    if (x < 0) x = width+r;
    if (y < -r) y = height+r;
    if (x > width+r) x = -r;
    if (y > height+r) y = -r;
    //println(x+","+y);
  }

}


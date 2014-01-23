class Shramp {

  VerletPhysics2D physics;
  ArrayList<Particle> particles;
  Particle head;
  boolean isDead;
  ArrayList<Spring> springs;
  //variables for timer
  float startTime, currTime;
  float hitTime;
  float x, y, r;

  boolean hungry;
  int meals;
  int starvecount;

  float mealtimer;
  float mealtime;



  Shramp(float _x, float _y) {
    physics = new VerletPhysics2D();
    physics.setDrag(0.02f);
    physics.setWorldBounds(new Rect(-50, -50, width+100, height+100));
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.02)));
    isDead = false;

    r=20;
    x=_x;
    y=_y;
    hitTime = random(500, 1000); 
    startTime = millis();

    hungry = false;
    mealtime = random(10000, 20000 );
    mealtimer=0;
    meals = 0;
    starvecount =0;
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
    head = particles.get(0);

    //heads.add(h);
    //give it antennae
    Particle a1 = new Particle(x, y, 2);
    Particle a2 = new Particle(x, y, 2);
    Spring as1 = new Spring(head, a1, 7, .2);
    Spring as2 = new Spring(head, a2, 7, .2);
    physics.addBehavior(new AttractionBehavior(a1, 15, -1.0f, 0.01f));
    physics.addBehavior(new AttractionBehavior(a2, 15, -1.0f, 0.01f));
    //get the tail
    Particle t = particles.get(particles.size()-1);
    //connect head and tail 
    Spring z = new Spring(head, t, 7, .001);
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

    mealtimer+=5;


    if (mealtimer>= mealtime) {
      hungry = true;
      starvecount++;
    }
    head.displayHead();
    for (Particle p : particles) {
      p.display();
    }

    for (Spring s: springs) {
      s.display();
    }

    currTime = millis() - startTime;

    if ( currTime >= hitTime & hungry == false ) {
      head.swim();
      startTime = millis();
      println("here"); 
    }
    if ( currTime >= hitTime & hungry == true ) {
      head.forrage();
      startTime = millis();

    }

    //this works
    if (hungry == true) {     
      starvecount++;
      if (starvecount > 1000) {
        head.alpha-=.1;
        if (head.alpha<=0) {
          isDead = true;
        }
      }
    }
    
    if (head.feed==1) {
      hungry = false; 
      println("SWITCH");    
      head.alpha = 200;
      starvecount = 0;
      mealtimer = 0;
      head.feed=0;
    }


    if (head.meals == 4 & shramps.size()<250) {
      shramps.add(new Shramp(head.x+5, head.y-5));
      head.meals = 0;
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

  //shramp needs to eat end buds of coral. logic?
  //do they breed?
}


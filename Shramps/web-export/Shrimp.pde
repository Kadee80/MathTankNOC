import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;

VerletPhysics2D physics;

ArrayList<Particle> particles;
ArrayList<Spring> springs;

//variables for timer
float startTime, currTime;
float hitTime;

void setup() {
  size(600, 600, P3D);
  smooth();
  hitTime = 1000; 
  startTime = millis();
  physics = new VerletPhysics2D();
  physics.setDrag(0.01f);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.02)));
  physics.update();
  particles = new ArrayList<Particle>();
  springs = new ArrayList<Spring>();
  Particle p;
  p = new Particle(width/2, height/2, 10);
  particles.add(p);
  physics.addBehavior(new AttractionBehavior(p, 50, -3.0f, 0.01f));
  physics.addParticle(p);

  for (int i = 1; i<8;i++) {
    Particle q;
    q = new Particle(width/2, height/2, 5);
    particles.add(q);
    physics.addBehavior(new AttractionBehavior(q, 50, -2.0f, 0.01f));
    physics.addParticle(q);
    Particle a = particles.get(i);
    Particle b = particles.get(i-1);
    Spring s = new Spring(a, b, 15, .02);
    springs.add(s);
    physics.addSpring(s);
  }


  //get the head
  Particle h = particles.get(0);
  //give it antennae
  Particle a1 = new Particle(width/2, height/2, 2);
  Particle a2 = new Particle(width/2, height/2, 2);
  Spring as1 = new Spring(h, a1, 20, .2);
  Spring as2 = new Spring(h,a2, 20, .2);
  physics.addBehavior(new AttractionBehavior(a1, 10, -1.0f, 0.01f));
  physics.addBehavior(new AttractionBehavior(a2, 10, -1.0f, 0.01f));
  //get the tail
  Particle t = particles.get(particles.size()-1);
  //connect head and tail 
  Spring z = new Spring(h, t, 50, .001);
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



void draw() {
  background(0);
  noStroke();
  fill(255);

  Particle c = particles.get(0);
  c.displayHead(c);
  c.swim(c);

  for (Particle p : particles) {
    p.display();
  }
  for (Spring s: springs) {
    s.display();
  }
  physics.update();
}



class Particle extends VerletParticle2D {
  float radius;

  Vec2D location;
  Vec2D velocity;
  Vec2D acceleration; 
  Vec2D noff;

  Particle(float x, float y, float rad) {
    super(x, y);
    radius =rad;
    location = new Vec2D(x, y);
    velocity = new Vec2D();
    acceleration = new Vec2D();
    noff = new Vec2D(random(1000), random(1000));
  }

  void display() {
    fill(255,100);
    noStroke();
    ellipse(x, y, radius, radius);
    //fill(255,100);
    //ellipse(x,y,35,35);
  }

  void displayHead(Vec2D c) {
    fill(255,200);
    noStroke();
    ellipse(c.x, c.y, radius*1.2, radius*1.2);
   
 
  }
  void swim(Particle c) {
    c.lock();
      // add a new particle every 0.5 seconds
   currTime = millis() - startTime;
 if( currTime >= hitTime )
 {
   startTime = millis();
       c.unlock();
    float r = random(0, 1);
    if (r<0.25) {
      c.x=c.x+20;
    }

    else if (r<0.5) {
      c.x=c.x-20;
    }
    else if (r<0.75) {
      c.y=c.y-20;
    }
    else {
      c.y=c.y+20;
    } 
    c.lock();
 }

  }
}


class Spring extends VerletSpring2D {
  
 Spring(Particle p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
  }

  void display() {
    strokeWeight(1);
    stroke(255,200);
    line(a.x, a.y, b.x, b.y);
  }
}


import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;


VerletPhysics2D physics;

AttractionBehavior mouseAttractor;
ArrayList<Particle> particles;
ArrayList<Spring> springs; 

PFont f;

Boolean IsParticleClicked;
Boolean IsParticleLocked;
Particle SelectedParticle;
//variables for timer
float startTime, currTime;
float hitTime;

void setup() {
  size(1280, 720, P3D);
  smooth();  
  hitTime = 200; 
  startTime = millis();
  
  physics = new VerletPhysics2D();
  physics.setDrag(0.2f);
  //physics.setWorldBounds(new Rect(0, 0, width, height));
  physics.update();
  particles = new ArrayList<Particle>();
  springs = new ArrayList<Spring>();
  //first particle in center
  Particle p;
  p = new Particle(width/2, height/2, 10, 4,5);
  particles.add(p);
  physics.addParticle(p);
  physics.addBehavior(new AttractionBehavior(p, 200, -4.0f, 0.01f));
}

void draw() {
  background(0);
// add a new particle every 0.3 seconds
   currTime = millis() - startTime;
 if( currTime >= hitTime )
 {
   startTime = millis();
   addParticle();
 }
 
 //dispay our system
  physics.update();
  Particle c = particles.get(0);
  c.lock();
  for (Particle p : particles) {
    p.display();
  }
  for (Spring s: springs) {
    s.display();
  }
  saveFrame("coral-######.jpg");
}



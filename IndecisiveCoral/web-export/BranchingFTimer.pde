import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;
PImage img;

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
  size(900, 900, P3D);
  smooth();  
  hitTime = 500; 
  startTime = millis();
  
  physics = new VerletPhysics2D();
  physics.setDrag(0.2f);
  //physics.setWorldBounds(new Rect(0, 0, width, height));
  physics.update();
  particles = new ArrayList<Particle>();
  springs = new ArrayList<Spring>();
  //first particle in center
  Particle p;
  p = new Particle(width/2, width/2, 10, 4,5);
  particles.add(p);
  physics.addParticle(p);
  physics.addBehavior(new AttractionBehavior(p, 200, -3.0f, 0.01f));
}

void draw() {
  background(0);
// add a new particle every 0.5 seconds
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
}


//logic for adding particles
void addParticle() {
  int r;
  float len = 60;
  float radius =70;
  float thickness;
  int jointSize;
  int podSize;
  r = int(random(particles.size()));
  
  //control spring length particle repulsion, and a few display vairables here
  if (particles.size()< 15) {
    thickness = 6;
    jointSize = 6;
    podSize = 4;
  }
  else if ( particles.size()< 50) {
    len = 50;
    radius = 55;
    thickness = 5;
    jointSize = 5;
    podSize = 3;
  }

  else if (particles.size()< 75) {
    len = 40;
    radius = 45;
    thickness = 4;
    jointSize = 4;
    podSize = 2;
  }

  else if (particles.size()< 100)  {
    len = 30;
    radius = 35;
    thickness = 3;
    jointSize = 3;
    podSize = 1;
  }
  
  else{
    len = 20;
    radius = 30;
    thickness = 2;
    jointSize = 2;
    podSize = 1;
  }
  
  //grab a previous particle to connect to
  Particle oldP = particles.get(r);
  //check to see if the particle we are attaching to doesnt have too many connections, if it does, pick another
  int numCon = oldP.countConnections();
  if (numCon >4) {
    println("too many connections, skipping");
    r = int(random(particles.size()-1));
    oldP = particles.get(r);
    numCon = oldP.countConnections();
  }
  
  else {
    //get the the average vector direction from previous connections and invert it
    Vec2D dir = oldP.getBranchDirection();
    //then add the new particle at the direction vector (from previous particle)
    Particle newP = new Particle(oldP.x+dir.x, oldP.y+dir.y, thickness/2,jointSize, podSize);
    particles.add(newP);
    //add repulsion
    physics.addBehavior(new AttractionBehavior(newP, radius, -2.3f, 0.01f));
    physics.addParticle(newP);
    //add the spring connection between old and new particle
    Spring s = new Spring(newP, oldP, len, .2, thickness);
    newP.addConnection(oldP);
    oldP.addConnection(newP);
    springs.add(s);
    physics.addSpring(s);
  }
}


//Get a particle based on coordinates, use these to detangle a messy coral
Particle GetParticleByCoordinate(int x, int y)
{
  Particle ParticleToReturn = new Particle(0, 0, 0,0,0);
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = (Particle) particles.get(i);
    if (particle.x == x && particle.y == y)
      ParticleToReturn = particle;
  }
  return ParticleToReturn;
}

void mousePressed() {
  if ( particles.size() >1) {
    for (int i = 0; i < particles.size(); i++) {
      Particle m = (Particle) particles.get(i);
      if (m.contains(mouseX, mouseY)) {
        //println("clicked on particle" + i +" particle is connected to particle:"  );
        IsParticleClicked = true;
        SelectedParticle = m;
      }
    }
  }
}

void mouseDragged() {
  if ( particles.size() > 5 &&IsParticleClicked ) {
    //Move Particle
    //println("about to move particle " + mouseX + "," + mouseY);
    SelectedParticle.lock();
    SelectedParticle.x = mouseX;
    SelectedParticle.y = mouseY;
    SelectedParticle.unlock();
    SelectedParticle.update();
  }
  else {
    //Do nothing
  }
}
void mouseReleased() {
  if ( particles.size() > 5 && IsParticleClicked) {
    //move particle
    //println("about to move particle to " + mouseX + "," + mouseY);
    SelectedParticle.x = mouseX;
    SelectedParticle.y = mouseY;
    SelectedParticle.update();
    IsParticleClicked = false;
  }
  else {
    //println("didnt click a particle");
  }
}


void keyPressed() {

  if (key == 'c') {
    setup();
  }

  if (key == 's')   
  {
    saveFrame ("nodes-####.png");
  }
}
class Particle extends VerletParticle2D {
  float thickness;
  int count;
  ArrayList<Particle> connections;
  float tx, ty;
  float xangle;
  float yangle;
  float js, ps;
  Vec2D self;
  Vec2D calculatedVector;
  Vec2D tent1, tent2, tent3, tent4;

  Particle(float x, float y, float twidth, int jointSize, int podSize) {
    super(x, y);
    connections = new ArrayList<Particle>();
    thickness = twidth;
    count = 0;
    self = new Vec2D(x, y);
    js = jointSize;
    ps = podSize;
  }

  void addConnection(Particle p) {
    connections.add(p);
  }


Vec2D getBranchDirection() {
    calculatedVector = new Vec2D(0, 0);
    for (Particle p : connections) {
      Vec2D dir = new Vec2D(p.x-x, p.y-y);
      calculatedVector.add(dir);
    }
    calculatedVector.normalizeTo(-20);
    return calculatedVector;
  }

  int countConnections() {
    return connections.size();
  }

  void display() {
    // harmonic motion calulations for tentacles
    tx = js*sin(xangle);
    xangle +=.05;
    ty = 2*js*sin(yangle);
    yangle+=.05;
    float heading = self.heading();

    tent1 = new Vec2D(x+ty*sin(heading), y+ty*cos(heading));
    tent2 = new Vec2D(x-ty*sin(heading), y+ty*sin(heading));
    tent3 = new Vec2D(x+ty*sin(heading), y-ty*cos(heading));
    tent4 = new Vec2D(x-ty*sin(heading), y-ty*sin(heading));
    
    fill(44,255,109,200);
    noStroke();
    ellipse(x, y, js, js);
    ellipse(tent1.x, tent1.y, ps, ps);
    ellipse(tent2.x, tent2.y, ps, ps);
    ellipse(tent3.x, tent3.y, ps, ps);
    ellipse(tent4.x, tent4.y, ps, ps);
    strokeWeight(thickness);
    stroke(196,255,196,200);
    line(x, y, tent1.x, tent1.y);
    line(x, y, tent2.x, tent2.y);
    line(x, y, tent3.x, tent3.y);
    line(x, y, tent4.x, tent4.y);
  }

  boolean contains(int x, int y) {
    float d = dist(x, y, this.x, this.y);
    if (d <= 15) { 
      return true;
    }
    else 
      return false;
  }
}

class Spring extends VerletSpring2D {
  float thick;


 Spring(Particle p1, Particle p2, float len, float strength, float thickness) {
    super(p1, p2, len, strength);
    thick = thickness;
  }

  void display() {
    strokeWeight(thick);
    //stroke(255,200);
    stroke(196,255,196,200);
    line(a.x, a.y, b.x, b.y);
  }
}




import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;


ArrayList<Coral> corals;
ArrayList<Shramp> shramps;
ArrayList<Particle> heads;
ArrayList <Feesh> feeshs;
ArrayList <Shramp> edibles;

Feesh fish;

boolean dragged = false;

float xloc, yloc;
int feeshLength;
void setup() {
  size(1024, 768, P3D);
  smooth();
  corals = new ArrayList<Coral>();
  shramps = new ArrayList<Shramp>();
  //heads = new ArrayList<Particle>();
  feeshs = new ArrayList();
  fish = new Feesh(0, 300, 5, 0, 170, 255);
  feeshs.add(fish);


  corals.add(new Coral(200, height-20, 10, 200, 100, 100));     
  corals.add(new Coral(800, height-10, 10, 200, 100, 100));
   corals.add(new Coral(500, height-30, 10, 200, 100, 100));

  for (int i = 0; i<100;i++) {
    xloc=random(width/2-100, width/2+100);
    yloc=random(height/2-200, height/2);
    Shramp s = new Shramp(xloc, yloc);
    shramps.add(s);
  }
}



void draw() {
  background(0);
  fill(255);
  textSize(10);
  text("press any key to add coral \n click mouse to add fish", 10, 10);

  noStroke();
  fill(255);
  for (int i = corals.size()-1; i>=0; i--) {
Coral c = corals.get(i);    
    c.grow();
    CParticle root = c.particles.get(0);
   if (root.isDead == true) {
      
      root.unlock();
      if (root.y< height-100){
        corals.remove(c);
        println(corals.size());
      }
    }
    }
  



  for (int i = shramps.size()-1; i>=0; i--) {
    Shramp shrimp = shramps.get(i);
    if (shrimp.isDead) {
      //println("dead");
      for (int j = shrimp.particles.size()-1; j>=0; j--) {
        Particle k = shrimp.particles.get(j);
        shrimp.particles.remove(k);
        shrimp.physics.removeParticle(k);
      }
      for (int j = shrimp.springs.size()-1; j>=0; j--) {
        Spring k = shrimp.springs.get(j);
        shrimp.springs.remove(k);
        shrimp.physics.removeSpring(k);
      }
      shramps.remove(shrimp);

      //println(shramps.size());
    }
    shrimp.go();
  }




  for (Feesh f: feeshs) {
    f.run();
    f.eat();
  }
}

//how can i make shramp without making a sine feesh?
void mouseReleased() {
  if (!dragged) {
    if (mouseY < height-100 & feeshs.size()<20) {
      feeshLength= int(random(4, 6));
      float r = random(0, 150);
      float g = random(0, 150);
      float b = random(200, 255);
      feeshs.add(new Feesh(mouseX, mouseY, feeshLength, r, g, b));
    }
    else if (mouseY > height-100 & corals.size()<10) {
      float r = random(10, 90);
      float g = random(200, 255);
      float b = random(90, 200);
      float a = random(100, 200);
      Coral c = new Coral(mouseX, mouseY, r, g, b, a );
      corals.add(c);
    }
  }
  dragged = false;
}

void mouseDragged() {
  dragged = true;
  shramps.add(new Shramp (mouseX, mouseY));
}

class CParticle extends VerletParticle2D {
  float thickness;
  int count;
  ArrayList<CParticle> connections;
  float tx, ty;
  float xangle;
  float yangle;
  float js, ps;
  Vec2D self;
  Vec2D calculatedVector;
  Vec2D tent1, tent2, tent3, tent4;
  boolean isDead;

  CParticle(float x, float y, float twidth, int jointSize, int podSize) {
    super(x, y);
    connections = new ArrayList<CParticle>();
    thickness = twidth;
    count = 0;
    self = new Vec2D(x, y);
    js = jointSize;
    ps = podSize;
    isDead = false;
  }

  void addConnection(CParticle p) {
    connections.add(p);
  }


Vec2D getBranchDirection() {
    calculatedVector = new Vec2D(0, 0);
    for (CParticle p : connections) {
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

class CSpring extends VerletSpring2D {
  float thick;
  float trans = random(150,250);
  color green;

 CSpring(CParticle p1, CParticle p2, float len, float strength, float thickness,color g) {
    super(p1, p2, len, strength);
    thick = thickness;
    green = g;
  }

  void display() {
    strokeWeight(thick*.8);
    stroke(green);
    line(a.x, a.y, b.x, b.y);
  }
}


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
    if ( currTime >= hitTime )
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

class Feesh {

  //  Bob [] bob; 
  //  Kspring [] Kspring; 

  ArrayList<Bob> bobs;
  ArrayList<Kspring> springs;

  Bob mouth;
  int meals;
  float x, y;
  int numJoints;
  float tx = 100;
  float ty= 1000;
  float r, g, b;
  color headColor;
  boolean chewing;
  int counter = 0;
  int mealtimer = 0;
  int mealtime;
  int starvecount;
  boolean hungry;

  //how do i grow the feesh's joint based on meals?
  //how do i kill it?

  float record ;
  Particle eat = null;

  Feesh(float _x, float _y, int _numJ, float _r, float _g, float _b) {
    x=_x;
    y=_y;
    r=_r;
    g=_g;
    b=_b;
    meals=0;
    starvecount=0;
    mealtime = int(random(300,700));
    numJoints = _numJ;
    headColor = color(r, g, b);
    chewing = false; 
    bobs = new ArrayList<Bob>();

    springs = new ArrayList<Kspring>();
    Bob b = new Bob(x, y, 0.99, headColor);
    mouth = b;
    bobs.add(b);


    for (int i = 1; i < numJoints; i++) {
      springs.add( new Kspring(7));
      bobs.add(new Bob(x, y+i*10, .8, headColor));
    }
  }

  void run() {
    float offset =0;
    PVector gravity = new PVector(0, 0.5);

    mouth.displayHead();
    mouth.update();
    mouth.wander();
    mealtimer ++;
    for (int i =1; i<bobs.size(); i++) {
      offset+=i;
      Bob b = bobs.get(i);
      Bob a = bobs.get(i-1);
      Kspring s = springs.get(i-1);
      b.applyForce(gravity);
      s.connect(b, a);
      s.constrainLength(b, a, 0, 15);
      b.update();
      s.displayLine(b, a); 
      b.display(offset);
    }
  }


  void eat() {

    if (mealtimer>= mealtime) {
      hungry = true;
      starvecount++;
    } 
    record = 1000;
    for (Shramp s : shramps) {
      PVector loc = new PVector(s.head.x, s.head.y);

      float d = PVector.dist(loc, mouth.location);

      if (hungry == true) {
        if (d <500 && d <record && s.head.edible ) {
          record = d;
          //println(record);
          eat = s.head;
          if (eat != null) {
            PVector food = loc;

            mouth.seek(food);
            mouth.headColor = color(255, 0, 255, 200);
            // if the food is in range, it gets eaten/deleted
            if (d<20) {
              chewing = true;
              s.isDead = true;
              record =1000;
              meals++;
              

              if (meals == 5) {
                mouth.maxspeed+=.1;
                mouth.maxforce+=.1;
                Bob a = bobs.get(bobs.size()-1);
                Bob b = new Bob(a.x, a.y, 0.99, headColor);
                
                bobs.add(b);
                springs.add(new Kspring(7));
                meals =0;
                
              }
            }
          }
        }
      }
      if (hungry == false) {
        mouth.headColor = color(r, g, b);
        starvecount =0;
        //mouth.wander();
      }
      if (chewing == true) {
        mouth.chew();
        hungry = false;
        mealtimer =0;

        counter++;
        if (counter== 3000) {
          chewing = false;
          counter = 0;
        }
      }
    }
  }
}


class Bob { 
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector noff;
  float offset;
  float mass =10;
  float xangle =0;
  float yangle = random(TWO_PI);
  float x, y;
  float damping;
  PVector fin;
  float heading;
  float r;
  float maxspeed;
  float maxforce;

  color headColor;
  float jaw = 1;
  float jangle =PI;


  Bob(float x, float y, float d, color _c) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    noff = new PVector(random(1000), random(1000));

    yangle = y/20;
    damping = d;
    r = 6;
    maxspeed = random(1, 2);
    maxforce = random(1, 2);
    headColor = _c;
  } 

  // Standard Euler integration
  void update() { 
    velocity.add(acceleration);
    velocity.mult(damping);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }


  // Newton's law: F = M * A
  // A= F/M
  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);
    acceleration.add(f);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    float d = desired.mag();
    // Scale with arbitrary damping within 100 pixels
    if (d < 100) {
      float m = map(d, 0, 100, 0, maxspeed);
      desired.setMag(m);
    } 
    else {
      desired.setMag(maxspeed);
    }

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }


  // Draw each segment
  void display(float o) { 
    stroke(255);
    fill(headColor, 100);
    x = 0;//1.5*offset*mass*sin(xangle);
    xangle +=.1;
    offset = o;
    //y = 2*offset*sin(yangle);
    y = 25*sin(yangle);
    yangle+=.1;
    stroke(175);
    strokeWeight(1);
    fill(110, 130, 230, 100);
    pushMatrix();
    translate(location.x, location.y);
    heading = velocity.heading2D();
    rotate(heading);
    triangle(5, 0, 0, 5, 0, -5);
    stroke(headColor, 200);
    strokeWeight(1);
    fill(headColor, 150);
    rectMode(CENTER);
    fin = new PVector(x, y);
    rect(fin.x, fin.y, 5, 5);
    line(0, 0, fin.x, fin.y);
    popMatrix();
  }

  void displayHead() {
    noStroke();
    fill(headColor, 200);
    pushMatrix();
    translate(location.x, location.y);
    float heading = velocity.heading2D();
    rotate(heading);
    triangle(0, 0, 10, 6+(jaw/2), 20, jaw);
    triangle(0, 0, 10, -6-(jaw/2), 20, -jaw);
    popMatrix();
  }

  void wander() {
    acceleration.x = map(noise(noff.x), 0, 1, -1, 1);
    acceleration.y = map(noise(noff.y), 0, 1, -1, 1);
    acceleration.mult(0.05);
    noff.add(0.01, 0.01, 0.0);
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
    location.x = constrain(location.x, -20, width+20);
    location.y = constrain(location.y, -20, height-10);
  }

  void chew() {
    jaw = 10*sin(jangle);
    jangle+=.1;
    jaw =map(jaw, -10, 10, 0, 5);
  }
}

class Kspring { 
  float len;
  float k = 0.4;

  Kspring(int l) {
    len = l;
  } 


  void connect(Bob b, Bob a) {
    // Vector pointing from anchor to bob location
    PVector force = PVector.sub(b.location, a.location);
    // What is distance
    float d = force.mag();
    // Stretch is difference between current distance and rest length
    float stretch = d - len;

    // Calculate force according to Hooke's Law
    // F = k * stretch
    force.normalize();
    force.mult(-1 * k * stretch);
    b.applyForce(force);
  }

  // Constrain the distance between bob and anchor between min and max
  void constrainLength(Bob b, Bob a, float minlen, float maxlen) {
    PVector dir = PVector.sub(b.location, a.location);
    float d = dir.mag();
    // Is it too short?
    if (d < minlen) {
      dir.normalize();
      dir.mult(minlen);
      // Reset location and stop from moving (not realistic physics)
      b.location = PVector.add(a.location, dir);
      b.velocity.mult(0);
      // Is it too long?
    } 
    else if (d > maxlen) {
      dir.normalize();
      dir.mult(maxlen);
      // Reset location and stop from moving (not realistic physics)
      b.location = PVector.add(a.location, dir);
      b.velocity.mult(0);
    }
  }

  //  void display() { 
  //    stroke(0);
  //    fill(175);
  //    strokeWeight(2);
  //    rectMode(CENTER);
  //    rect(a.x, a.y, 10, 10);
  //  }

  void displayLine(Bob b, Bob a) {
    strokeWeight(.5);
    stroke(255);
    line(b.location.x, b.location.y, a.location.x, a.location.y);
  }
}

class Particle extends VerletParticle2D {
  float radius;
  color hcolor;
  boolean edible;
  int buddycount;
  Vec2D location;
  Vec2D velocity;
  Vec2D acceleration; 
  boolean hungry;
  boolean isFed;
  int meals;
  float alpha;


  Particle(float x, float y, float rad) {
    super(x, y);
    radius =rad;
    //location = new Vec2D(x, y);
    velocity = new Vec2D();
    acceleration = new Vec2D();
    edible = false;
    hungry = false;
    isFed = false;
    alpha = 250;
  }

  void display() {
    fill(hcolor, 175);
    noStroke();
    ellipse(x, y, radius, radius);
    //fill(255,100);
    //ellipse(x,y,35,35);
  }

  void displayHead() {
    if (edible == false) {
      hcolor = color(255, 0, 80, alpha);
    }
    if (edible == true) {
      hcolor = color(180, 10, 250, alpha);
      ellipse(x, y, radius*1.4, radius*1.4);
    }
    if (hungry == true) {
      hcolor = color(255, 255, 0, alpha);
    }

    fill(hcolor, 200);
    noStroke();
    ellipse(x, y, radius*1.1, radius*1.1);

    //fill(255);
    //textSize(10);
    //text(buddycount, x, y-10);
  }


  void swim() {
    unlock();
    float r = random(0, 1);
    if (r<0.92) {
      for (Shramp s : shramps) {

        float d = distanceTo(s.head);

        if (s.head.x<10) {
          velocity.set(10, 0);
        }
        else if (s.head.x>width-10) {
          velocity.set(-10, 0);
        }
        else if (s.head.y<10) {
          velocity.set(0, 10);
        }
        else if (s.head.y>height-100) {
          velocity.set(0, -10);
        }

        else if (d <200) {
          hcolor = color(255, 255, 255, 100);
          velocity.x = s.head.velocity.x;
          velocity.y = s.head.velocity.y;
        }
      }
    }

    //up
    else if (r<0.93) {
      velocity.set(0, -20);
    }
    //up rt
    else if (r<0.94) {
      velocity.set(20, -20);
    }
    //rt
    else if (r<0.95) {
      velocity.set(20, 0);
    }
    // rt dn
    else if (r<0.96) {
      velocity.set(20, 20);
    }
    // dn
    else if (r<0.97) {
      velocity.set(0, 20);
    }
    //dn lt
    else if (r<0.98) {
      velocity.set(-20, 20);
    }
    // lt
    else if (r<0.99) {
      velocity.set(-20, 0);
    }
    else {
      velocity.set(-20, -20);
    }
    lock();

    addSelf(velocity);
    checkEdible();
    checkMeals();
  }

  void forrage() {
    unlock();
       fill(255,165,0,150);
    ellipse( x, y,15,15);
    float r = random(0, 1);
 
    
        if (r<0.5) {
      for (Shramp s : shramps) {

        float d = distanceTo(s.head);

        if (s.head.x<10) {
          velocity.set(10, 0);
        }
        else if (s.head.x>width-10) {
          velocity.set(-10, 0);
        }
        else if (s.head.y<10) {
          velocity.set(0, 10);
        }
        else if (s.head.y>height-100) {
          velocity.set(0, -10);
        }

        else if (d <200) {
          hcolor = color(255, 255, 255, 100);
          velocity.x = s.head.velocity.x;
          velocity.y = s.head.velocity.y;
        }
      }
    }

    else if (r < 0.6) {
      velocity.set(20, 20);
    }
    //down left
    else if ( r < 0.7) {
      velocity.set(-20, 20);
    }
    //right
    else if ( r < 0.8) {
      velocity.set(20, 0);    
    }
    //left
    else if ( r<0.9 ) {
      velocity.set(-20, 0);
    }
    //down
    else {
      velocity.set(0, 20);
    }



    lock();
    addSelf(velocity);
    checkEdible();
    checkMeals();
  }

  void checkEdible() {
    buddycount = 0;
    for (Shramp s : shramps) {
      float d = distanceTo(s.head);
      if (d<50) {
        buddycount++;
      }
    }

    if (buddycount < 2) {
      edible =true;
    }
    else {
      edible =false;
    }
  }
  void checkMeals() {
    for (Coral c : corals) {
      for (CParticle p : c.particles) {
        float d = distanceTo(p);
        if (d < 20 & isFed == false) {
          p.isDead = true;
          isFed =true;
          meals++;
        }
      }
    }
  }
}

class Shramp {

  VerletPhysics2D physics;
  ArrayList<Particle> particles;
  Particle head;
  boolean isDead;
  ArrayList<Spring> springs;
  //variables for timer
  float startTime, currTime;
  float hitTime;

  float startTimeF, currTimeF;
  float foodHit;
  float x, y, r;

  boolean hungry;
  int meals;
  int starve;


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
    foodHit = random(10000, 20000 );
    startTime = millis();
    startTimeF = millis();
    hungry = false;
    meals = 0;
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


    head.displayHead();

    currTime = millis() - startTime;
    currTimeF = millis() - startTimeF;


    if ( currTime >= hitTime & hungry == false ) {
      head.swim();
      startTime = millis();
    }
    
    

    else if ( currTimeF >= foodHit) {
      hungry = true;
      //head.hcolor = color(255,255,0,head.alpha);
    }

    if (currTime >= hitTime & hungry == true) {
      head.forrage(); 
      startTime = millis();
    }
    //this works
    if (hungry == true) {
      starve++;
      if (starve > 1000) {
        head.alpha-=.1;
        if (head.alpha<=0) {
          isDead = true;
        }
      }
    }
    
    if (head.isFed == true) {
      hungry = false;
      head.alpha = 200;
      startTimeF = millis();
      head.isFed = false;
    }
    
    if (head.meals == 2){
      shramps.add(new Shramp(head.x+5,head.y-5));
      head.meals = 0;
      
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

  //shramp needs to eat end buds of coral. logic?
  //do they breed?
}

class Spring extends VerletSpring2D {

  Spring(Particle p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
  }

  void display() {
    strokeWeight(1);
    stroke(255, 0, 77, 175);
    line(a.x, a.y, b.x, b.y);
  }
}



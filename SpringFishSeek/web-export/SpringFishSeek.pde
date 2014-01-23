
Bob [] bob = new Bob[10];
Spring [] spring = new Spring[10];
Bob head;

ArrayList <Food> food;


void setup() {
  size(800, 800);
  background(0); 
  bob[0] = new Bob(width/2, height/2, .99);
  head = bob[0];
  for (int i =1; i<bob.length; i++) {
    spring[i] = new Spring(10); 
    bob[i] = new Bob(width/2, i*10,.8);
    food = new ArrayList <Food>();
  }
}

void draw() {
  background(0); 
  fill(0, 5);
  rectMode(CORNER);
  rect(0, 0, width, height);
  float tx = 100;
  float ty= 1000;

  PVector gravity = new PVector(0, 0.5);
  PVector mouse = new PVector(mouseX, mouseY);
  PVector mouth = new PVector (head.x,head.y);
  float offset =0;

  head.displayHead();
  head.update();


  for (int i =1; i<bob.length; i++) {
    offset+=i;
    bob[i].applyForce(gravity);
    spring[i].connect(bob[i], bob[i-1]);
    spring[1].constrainLength(bob[i], bob[i-1], 0, 30);
    bob[i].update();
    spring[i].displayLine(bob[i], bob[i-1]); 
    bob[i].display(offset);
   
  }
  
 float record = 10000;
 Food eat = null;

 for (Food f : food) {
   f.display();
   f.wander();
 
   float d = PVector.dist(f.location, head.location);
   println(d);
   if (d < 300 & d < record) {
     record = d;
     eat = f;
   }
 }

 if (eat != null) {
   head.seek(eat.location);
 }
 else {
   head.seek(mouse);
 }

  
  
}

void mousePressed(){
  food.add(new Food(mouseX,mouseY));
  
}



class Bob { 
  PVector location;
  PVector velocity;
  PVector acceleration;
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


  Bob(float x, float y, float d) {
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    
    yangle = y/20;
    damping = d;
    r = 6;
    maxspeed = 10;
    maxforce = 0.1;
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
PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    float d = desired.mag();
    // Scale with arbitrary damping within 100 pixels
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.setMag(m);
    } else {
      desired.setMag(maxspeed);
    }

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }


  // Draw each segment
  void display(float o) { 
    stroke(255);
    noFill();
    x = 0;//1.5*offset*mass*sin(xangle);
    xangle +=.1;
    offset = o;
    //y = 2*offset*sin(yangle);
    y = 40*sin(yangle);
    yangle+=.1;
    stroke(175);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    heading = velocity.heading2D();
    rotate(heading);
    triangle(10, 0, 0, 5, 0, -5);
    stroke(255, 150);
    strokeWeight(1);
    rectMode(CENTER);
    fin = new PVector(x, y);
    rect(fin.x, fin.y, 5, 5);
    line(0, 0, fin.x, fin.y);
    popMatrix();
    //fill(255,150);
    //ellipse(location.x, location.y, mass*2, mass*2);
  }

  void displayHead() {

    noStroke();
    fill(255, 0, 0, 150);
    pushMatrix();
    translate(location.x, location.y);
    float heading = velocity.heading2D();
    rotate(heading);
    triangle(10, 0, 0, 5, 0, -5);
    popMatrix();
  }

}


class Spring { 
  float len;
  float k = 0.1;

  Spring(int l) {
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

class Food {

  PVector location;
  PVector velocity;
  PVector acceleration; 
  PVector noff;
  float mass =5;

  Food(float x, float y) {
    noff = new PVector(random(1000), random(1000));
    location = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
  }
  

  void wander() {
    acceleration.x = map(noise(noff.x), 0, 1, -5, 5);
    acceleration.y = map(noise(noff.y), 0, 1, -5, 5);
    acceleration.mult(0.1);
    noff.add(0.01, 0.01, 0);
    velocity.add(acceleration);
    velocity.limit(1);
    location.add(velocity);
    
    location.x = constrain(location.x,0,width);
    location.y = constrain(location.y,0,height);
  }

  void display() {
    fill(13, 255, 83);
    ellipse(location.x,location.y, 20, 20);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

}



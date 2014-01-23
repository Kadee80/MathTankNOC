
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



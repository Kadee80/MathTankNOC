
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


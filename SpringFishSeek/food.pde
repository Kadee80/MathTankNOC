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


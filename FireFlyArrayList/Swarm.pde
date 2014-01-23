class Swarm {
  ArrayList<Fly> s;

  PVector location;
  PVector velocity = new PVector(0, 0);
  PVector acceleration = new PVector(0, 0);
  PVector mouse; 
  //PVector force;

  Swarm(int num, PVector o) {
    s = new ArrayList<Fly>();   
    location = o.get();                        
    for (int i = 0; i < num; i++) {
      s.add(new Fly(location));
    }
  }

  void run() {
    for (Fly f: s) {
      f.fly(); 
      f.display();
      fill(255, 0, 0);
      ellipse(location.x, location.y, 2, 2);
    }
  }


  void applyForce(PVector _f) {
    acceleration.add(_f);
    velocity.add(acceleration);
    velocity.limit(3);
    location.add(velocity);

    acceleration.mult(0);
  }


  void update() { 
    velocity.add(acceleration);
    location.add(velocity);

    acceleration.mult(0);
  }

  void boundaries() {
    float d = 20;
    PVector force = new PVector(0, 0);
    if (location.x < d) {
      force.x = 1;
    } 
    else if (location.x > width -d) {
      force.x = -1;
    } 
    if (location.y < d) {
      force.y = 1;
    } 
    else if (location.y > height-d) {
      force.y = -1;
    } 

    force.normalize();
    force.mult(1);
    applyForce(force);
  }
}


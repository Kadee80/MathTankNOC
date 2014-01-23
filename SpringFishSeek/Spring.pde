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


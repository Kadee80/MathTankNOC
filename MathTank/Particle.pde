class Particle extends VerletParticle2D {
  float radius;
  color hcolor;
  boolean edible;
  int buddycount;
  Vec2D location;
  Vec2D velocity;
  Vec2D acceleration; 
  boolean hungry;
  int feed;
  int meals;
  float alpha;


  Particle(float x, float y, float rad) {
    super(x, y);
    radius =rad;
    //location = new Vec2D(x, y);
    velocity = new Vec2D();
    acceleration = new Vec2D();
    edible = false;
    alpha = 250;
  }



  void displayHead() {
    if (edible == false) {
      hcolor = color(255, 0, 80, alpha);
    }
    if (edible == true) {
      hcolor = color(180, 10, 250, alpha);
      ellipse(x, y, radius*1.2, radius*1.2);
    }

    fill(hcolor, 200);
    noStroke();
    ellipse(x, y, radius*1.1, radius*1.1);

    //fill(255);
    //textSize(10);
    //text(buddycount, x, y-10);
  }
  
    void display() {
    fill(255, 0, 80, alpha/3);
    noStroke();
    ellipse(x, y, 3, 3);
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
        else if (s.head.y>height-300) {
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
    //checkMeals();
  }

  void forrage() {
    unlock();
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
        else if (s.head.y>height-400) {
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
  //this is where coral is eaten, need to fix it here
  void checkMeals() {
    for (Coral c : corals) {
      for (CParticle p : c.particles) {
        float d = distanceTo(p);
        if (d < 20) {
          p.isDead = true;
          meals++;
       feed++;   
        }
      }
    }
  }
}


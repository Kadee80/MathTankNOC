class Particle extends VerletParticle2D {
  float radius;
  color hcolor;
  boolean edible;
  int buddycount;
  Vec2D location;
  Vec2D velocity;
  Vec2D acceleration; 



  Particle(float x, float y, float rad) {
    super(x, y);
    radius =rad;
    location = new Vec2D(x, y);
    velocity = new Vec2D();
    acceleration = new Vec2D();
    hcolor = color(255, 255, 255, 100);
    edible = false;
  }

  void display() {
    fill(hcolor, 200);
    noStroke();
    ellipse(x, y, radius, radius);
    //fill(255,100);
    //ellipse(x,y,35,35);
  }

  void displayHead() {
    if (edible == false) {
      hcolor = color(255,0,80);
    }
    else {
      hcolor = color(255,75,0);
    }
    fill(hcolor, 200);
    noStroke();
    ellipse(x, y, radius*1.2, radius*1.2);
    
    fill(255);
    textSize(10);
    text(buddycount,x,y-10);
  }


  void swim() {
    unlock();
    float r = random(0, 1);



    if (r<0.8) {
      for (Particle h : heads) {
        float d = distanceTo(h);
        if ( d <200) {
          hcolor = color(255, 255, 255, 100);
          velocity.x = h.velocity.x;
          velocity.y = h.velocity.y;
        }
      }
    }

    else if (r<0.85) {
      velocity.set(20, 0);
    }

    else if (r<0.9) {
      velocity.set(-20, 0);
    }
    else if (r<0.95) {
      velocity.set(0, -20);
    }
    else {
     if (location.y > height-50){
        velocity.set(0,-20);
    }
    else{
      velocity.set(0, 20);
     }
    } 
    lock();

    addSelf(velocity);
    checkEdible();
  }

  void checkEdible() {
    buddycount = 0;
    for (Particle h : heads) {
      float d = distanceTo(h);
      if (d<50) {
        buddycount++;
      }
    }
    
    //noFill();
    //stroke(255);
    //ellipse(x,y,400,400);

    if (buddycount < 2) {
      edible =true;
    }
    else {
      edible =false;
    }
  }
}


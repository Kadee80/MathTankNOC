import java.util.*;
Random generator;
PVector food;
PVector w = new PVector(0.1, 0);
ArrayList<Swarm> swarms;
void setup() {
  size(800, 800);
  generator = new Random();
  background(0);
  swarms = new ArrayList<Swarm>();

  food = new PVector (width/2, height/2);
}

void draw() {
  fill(0, 100);
  rect(0, 0, width, height);
  fill(0, 255, 0, 100);
  ellipse(food.x, food.y, 50, 50);

  for (Swarm s: swarms) {
    s.run();
    PVector att =  PVector.sub(food, s.location);
    att.normalize();
    att.mult(.1);
    if (keyPressed){
      att.mult(-1);
    }
    s.applyForce(att);
    s.boundaries();
  }
}


void mousePressed() {
  swarms.add(new Swarm(10, new PVector(mouseX, mouseY)));
}



class Fly {
  PVector origin;
  PVector loc;
  PVector vel;
  PVector acc;

  float offset = random(1000);
  float rad;
  float sd = 10; 
  float mean = 10;
  float opacity;

  Fly(PVector o) {
    origin = o;
    loc = new PVector(0,0);
    vel = new PVector(random(1000), random(1000));
  }
  
    void fly() {
    //make them swarm around the origin
    loc.x  = map(noise(vel.x), 0, 1, origin.x-100, origin.x+100);
    loc.y  = map(noise(vel.y), 0, 1, origin.y-100, origin.y+100); 
    vel.add(0.01, 0.01, 0);
  }
  
   void display() {
    noStroke();
    rad =(float) generator.nextGaussian();
    rad = rad*10;
    rad=rad+5;
    opacity = 255/rad *2.5;
    fill(230, 250, 90, opacity);
    ellipse (loc.x, loc.y, rad, rad);

  }
}

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



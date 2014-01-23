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




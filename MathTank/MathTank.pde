import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;

PFont font;


ArrayList<Coral> corals;
ArrayList<Shramp> shramps;
ArrayList<Particle> heads;
ArrayList <Feesh> feeshs;
ArrayList <Shramp> edibles;

int maxFeesh =25;
int maxCoral = 10;
int maxShramp = 250;

Feesh fish;

boolean dragged = false;

float xloc, yloc;
int feeshLength;
void setup() {
  size(displayWidth, displayHeight, P3D);
  smooth();
  font = loadFont("AppleGothic-12.vlw");
  corals = new ArrayList<Coral>();
  shramps = new ArrayList<Shramp>();
  //heads = new ArrayList<Particle>();
  feeshs = new ArrayList();
  fish = new Feesh(0, 300, 5, 0, 170, 255);
  feeshs.add(fish);


  corals.add(new Coral(200, height-20, 10, 200, 100, 100));     
  corals.add(new Coral(800, height-10, 10, 200, 100, 100));
  corals.add(new Coral(500, height-30, 10, 200, 100, 100));

  for (int i = 0; i<10;i++) {
    xloc=random(width/2-100, width/2+100);
    yloc=random(height/2-200, height/2);
    Shramp s = new Shramp(xloc, yloc);
    shramps.add(s);
  }
}



void draw() {
  background(0);
  fill(200, 255, 200);
  textFont(font, 12);
  text("click mouse in tank to add a feesh \nclick mouse on sea floor to plant coral \ndrag mouse to add shramp \nright click to reset tank", 10, 10);
  text("feesh  left: " + (maxFeesh- feeshs.size()) + "\nshramp  left: " + (maxShramp- shramps.size()) + "\ncoral  left: " + (maxCoral- corals.size()), width-100, 10);

  noStroke();
  fill(255);

  //corals
  for (int i = corals.size()-1; i>=0; i--) {
    Coral c = corals.get(i);    
    c.grow();
    CParticle root = c.particles.get(0);
    if (root.isDead == true) {

      root.unlock();
      if (root.y< 100) {
        corals.remove(c);
        println(corals.size());
      }
    }
  }
  //shramp/////////////////////////////////////
  for (int i = shramps.size()-1; i>=0; i--) {
    Shramp shrimp = shramps.get(i);
    if (shrimp.isDead) {
      //println("dead");
      for (int j = shrimp.particles.size()-1; j>=0; j--) {
        Particle k = shrimp.particles.get(j);
        shrimp.particles.remove(k);
        shrimp.physics.removeParticle(k);
      }
      for (int j = shrimp.springs.size()-1; j>=0; j--) {
        Spring k = shrimp.springs.get(j);
        shrimp.springs.remove(k);
        shrimp.physics.removeSpring(k);
      }
      shramps.remove(shrimp);
    }
    shrimp.go();
  }
  //feesh//////////////////////////////////////
  for (Feesh f: feeshs) {
    f.run();
    f.eat();
  }

  for (int j = feeshs.size()-1; j>=0; j--) {
    Feesh f = feeshs.get(j);
    if (f.isDead == true) {
      feeshs.remove(j);
    }
  }
  

  //if is emtpy
  if (shramps.size()==0) {

    for (int i=0; i<10;i++) {
      Shramp s = new Shramp(xloc+i*2, yloc+i*5);
      shramps.add(s);
    }
  }
  if (corals.size()==0) {
    corals.add(new Coral(500, height-30, 10, 200, 100, 100));
  }
  if (feeshs.size()==0) {
    feeshs.add(new Feesh(100, 100, 5, 0, 170, 255));
  }
}


void mouseReleased() {
  if (!dragged) {
    if (mouseY < height-100 & feeshs.size()<maxFeesh) {
      feeshLength= int(random(4, 6));
      float r = random(0, 150);
      float g = random(0, 150);
      float b = random(200, 255);
      feeshs.add(new Feesh(mouseX, mouseY, feeshLength, r, g, b));
    }
    else if (mouseY > height-100 & corals.size()<maxCoral) {
      float r = random(10, 90);
      float g = random(200, 255);
      float b = random(90, 200);
      float a = random(100, 200);
      Coral c = new Coral(mouseX, mouseY, r, g, b, a );
      corals.add(c);
    }
  }
  if (mouseButton == RIGHT) {
    setup();
    size(displayWidth, displayHeight, P3D);
    smooth();
    font = loadFont("AppleGothic-12.vlw");
    corals = new ArrayList<Coral>();
    shramps = new ArrayList<Shramp>();
    //heads = new ArrayList<Particle>();
    feeshs = new ArrayList();
    fish = new Feesh(0, 300, 5, 0, 170, 255);
    feeshs.add(fish);


    corals.add(new Coral(200, height-20, 10, 200, 100, 100));     
    corals.add(new Coral(800, height-10, 10, 200, 100, 100));
    corals.add(new Coral(500, height-30, 10, 200, 100, 100));

    for (int i = 0; i<10;i++) {
      xloc=random(width/2-100, width/2+100);
      yloc=random(height/2-200, height/2);
      Shramp s = new Shramp(xloc, yloc);
      shramps.add(s);
    }
  }
  
  dragged = false;
}

void mouseDragged() {
  dragged = true;
  if (shramps.size()<maxShramp) {
    shramps.add(new Shramp (mouseX, mouseY));
  }
}




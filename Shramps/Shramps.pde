import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;



ArrayList<Shramp> shramps;
ArrayList<Particle> heads;

float xloc, yloc;

void setup() {
  size(1024, 768, P3D);
  smooth();
  shramps = new ArrayList<Shramp>();

heads = new ArrayList<Particle>();


  //physics.update();
  for (int i = 0; i<50;i++) {
    xloc=random(width/2-100, width/2+100);
    yloc=random(height/2-100, height/2+100);
    Shramp s = new Shramp(xloc, yloc);
    shramps.add(s);
  }
}



void draw() {
  background(0);
  noStroke();
  fill(255);
  for (Shramp s: shramps) {
    s.go();
    
  }

}


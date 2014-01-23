import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import toxi.math.*;




ArrayList<Coral> corals;

void setup() {
  size(1200, 800, P3D);
  smooth();

  corals = new ArrayList<Coral>();
}

void draw() {
  background(0);
      for (Coral c : corals) {
      c.grow();
    }
}

void mousePressed(){
  Coral c = new Coral(mouseX,mouseY);
  corals.add(c);
}


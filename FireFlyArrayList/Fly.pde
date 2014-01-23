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


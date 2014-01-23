class CSpring extends VerletSpring2D {
  float thick;
  float trans = random(150,250);
  color green;

 CSpring(CParticle p1, CParticle p2, float len, float strength, float thickness,color g) {
    super(p1, p2, len, strength);
    thick = thickness;
    green = g;
  }

  void display() {
    strokeWeight(thick*.8);
    stroke(green);
    line(a.x, a.y, b.x, b.y);
  }
}



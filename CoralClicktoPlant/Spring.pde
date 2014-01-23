class CSpring extends VerletSpring2D {
  float thick;


 CSpring(CParticle p1, CParticle p2, float len, float strength, float thickness) {
    super(p1, p2, len, strength);
    thick = thickness;
  }

  void display() {
    strokeWeight(thick);
    //stroke(255,200);
    stroke(196,255,196,200);
    line(a.x, a.y, b.x, b.y);
  }
}



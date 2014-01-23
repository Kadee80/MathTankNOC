class Spring extends VerletSpring2D {

  Spring(Particle p1, Particle p2, float len, float strength) {
    super(p1, p2, len, strength);
  }

  void display() {
    strokeWeight(1);
    stroke(255, 0, 77, 175);
    line(a.x, a.y, b.x, b.y);
  }
}


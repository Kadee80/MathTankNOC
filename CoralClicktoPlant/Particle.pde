class CParticle extends VerletParticle2D {
  float thickness;
  int count;
  ArrayList<CParticle> connections;
  float tx, ty;
  float xangle;
  float yangle;
  float js, ps;
  Vec2D self;
  Vec2D calculatedVector;
  Vec2D tent1, tent2, tent3, tent4;

  CParticle(float x, float y, float twidth, int jointSize, int podSize) {
    super(x, y);
    connections = new ArrayList<CParticle>();
    thickness = twidth;
    count = 0;
    self = new Vec2D(x, y);
    js = jointSize;
    ps = podSize;
  }

  void addConnection(CParticle p) {
    connections.add(p);
  }


Vec2D getBranchDirection() {
    calculatedVector = new Vec2D(0, 0);
    for (CParticle p : connections) {
      Vec2D dir = new Vec2D(p.x-x, p.y-y);
      calculatedVector.add(dir);
    }
    calculatedVector.normalizeTo(-20);
    return calculatedVector;
  }

  int countConnections() {
    return connections.size();
  }

  void display() {
    // harmonic motion calulations for tentacles
    tx = js*sin(xangle);
    xangle +=.05;
    ty = 2*js*sin(yangle);
    yangle+=.05;
    float heading = self.heading();

    tent1 = new Vec2D(x+ty*sin(heading), y+ty*cos(heading));
    tent2 = new Vec2D(x-ty*sin(heading), y+ty*sin(heading));
    tent3 = new Vec2D(x+ty*sin(heading), y-ty*cos(heading));
    tent4 = new Vec2D(x-ty*sin(heading), y-ty*sin(heading));
    
    fill(44,255,109,200);
    noStroke();
    ellipse(x, y, js, js);
    ellipse(tent1.x, tent1.y, ps, ps);
    ellipse(tent2.x, tent2.y, ps, ps);
    ellipse(tent3.x, tent3.y, ps, ps);
    ellipse(tent4.x, tent4.y, ps, ps);
    strokeWeight(thickness);
    stroke(196,255,196,200);
    line(x, y, tent1.x, tent1.y);
    line(x, y, tent2.x, tent2.y);
    line(x, y, tent3.x, tent3.y);
    line(x, y, tent4.x, tent4.y);
  }

  boolean contains(int x, int y) {
    float d = dist(x, y, this.x, this.y);
    if (d <= 15) { 
      return true;
    }
    else 
      return false;
  }
}


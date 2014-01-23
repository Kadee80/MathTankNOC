//logic for adding particles
void addParticle() {
  int r;
  float len = 60;
  float radius =70;
  float thickness;
  int jointSize;
  int podSize;
  r = int(random(particles.size()));
  
  //control spring length particle repulsion, and a few display vairables here
  if (particles.size()< 15) {
    thickness = 5;
    jointSize = 6;
    podSize = 5;
  }
  else if ( particles.size()< 50) {
    len = 50;
    radius = 55;
    thickness = 4;
    jointSize = 5;
    podSize = 4;
  }

  else if (particles.size()< 75) {
    len = 40;
    radius = 45;
    thickness = 3;
    jointSize = 4;
    podSize = 3;
  }

  else if (particles.size()< 100)  {
    len = 30;
    radius = 35;
    thickness = 2;
    jointSize = 3;
    podSize = 2;
  }
  
  else{
    len = 20;
    radius = 30;
    thickness = 2;
    jointSize = 2;
    podSize = 2;
  }
  
  //grab a previous particle to connect to
  Particle oldP = particles.get(r);
  //check to see if the particle we are attaching to doesnt have too many connections, if it does, pick another
  int numCon = oldP.countConnections();
  if (numCon >4) {
    println("too many connections, skipping");
    r = int(random(particles.size()-1));
    oldP = particles.get(r);
    numCon = oldP.countConnections();
  }
  
  else {
    //get the the average vector direction from previous connections and invert it
    Vec2D dir = oldP.getBranchDirection();
    //then add the new particle at the direction vector (from previous particle)
    Particle newP = new Particle(oldP.x+dir.x, oldP.y+dir.y, thickness/2,jointSize, podSize);
    particles.add(newP);
    //add repulsion
    physics.addBehavior(new AttractionBehavior(newP, radius, -2.3f, 0.01f));
    physics.addParticle(newP);
    //add the spring connection between old and new particle
    Spring s = new Spring(newP, oldP, len, .2, thickness);
    newP.addConnection(oldP);
    oldP.addConnection(newP);
    springs.add(s);
    physics.addSpring(s);
  }
}


//Get a particle based on coordinates, use these to detangle a messy coral
Particle GetParticleByCoordinate(int x, int y)
{
  Particle ParticleToReturn = new Particle(0, 0, 0,0,0);
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = (Particle) particles.get(i);
    if (particle.x == x && particle.y == y)
      ParticleToReturn = particle;
  }
  return ParticleToReturn;
}

void mousePressed() {
  if ( particles.size() >1) {
    for (int i = 0; i < particles.size(); i++) {
      Particle m = (Particle) particles.get(i);
      if (m.contains(mouseX, mouseY)) {
        //println("clicked on particle" + i +" particle is connected to particle:"  );
        SelectedParticle = m;
        IsParticleClicked = true;
      }
    }
  }
}

void mouseDragged() {
  if ( particles.size() > 5 && IsParticleClicked ) {
    //Move Particle
    //println("about to move particle " + mouseX + "," + mouseY);
    SelectedParticle.lock();
    SelectedParticle.x = mouseX;
    SelectedParticle.y = mouseY;
    SelectedParticle.unlock();
    SelectedParticle.update();
  }
  else {
    //Do nothing
  }
}
void mouseReleased() {
  if ( particles.size() > 5 && IsParticleClicked) {
    //move particle
    //println("about to move particle to " + mouseX + "," + mouseY);
    SelectedParticle.x = mouseX;
    SelectedParticle.y = mouseY;
    SelectedParticle.update();
    IsParticleClicked = false;
  }
  else {
    //println("didnt click a particle");
  }
}


void keyPressed() {

  if (key == 'c') {
    setup();
  }

  if (key == 's')   
  {
    saveFrame ("nodes-####.png");
  }
}

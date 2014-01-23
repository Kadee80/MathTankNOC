Bob [] bob = new Bob[10];
Spring [] spring = new Spring[10];
Bob head;

ArrayList <Food> food;
//ArrayList <Fish> feesh;


void setup() {
  size(800, 800);
  background(0); 
  bob[0] = new Bob(width/2, height/2, .99);
  head = bob[0];
  for (int i =1; i<bob.length; i++) {
    spring[i] = new Spring(7); 
    bob[i] = new Bob(width/2, i*10,.8);
    food = new ArrayList <Food>();
  }
}

void draw() {
  background(0); 
  fill(0, 5);
  rectMode(CORNER);
  rect(0, 0, width, height);
  float tx = 100;
  float ty= 1000;

  PVector gravity = new PVector(0, 0.5);
  PVector mouse = new PVector(width, height);
  PVector mouth = new PVector (head.x,head.y);
  float offset =0;

  head.displayHead();
  head.update();


  for (int i =1; i<bob.length; i++) {
    offset+=i;
    bob[i].applyForce(gravity);
    spring[i].connect(bob[i], bob[i-1]);
    spring[1].constrainLength(bob[i], bob[i-1], 0, 30);
    bob[i].update();
    spring[i].displayLine(bob[i], bob[i-1]); 
    bob[i].display(offset);
   
  }
  
 float record = 10000;
 Food eat = null;

 for (Food f : food) {
   f.display();
   f.wander();
 
   float d = PVector.dist(f.location, head.location);
   println(d);
   if (d < 300 & d < record) {
     record = d;
     eat = f;
   }
 }

 if (eat != null) {
   head.seek(eat.location);
 }
 else {
   head.seek(mouse);
 }

  
  
}

void mousePressed(){
  food.add(new Food(mouseX,mouseY));
  
}



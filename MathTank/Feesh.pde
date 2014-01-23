class Feesh {

  //  Bob [] bob; 
  //  Kspring [] Kspring; 

  ArrayList<Bob> bobs;
  ArrayList<Kspring> springs;

  Bob mouth;
  int meals;

  float x, y;
  int numJoints;
  float tx = 100;
  float ty= 1000;
  float r, g, b;
  color headColor;
  boolean chewing;
  int counter = 0;
  int mealtimer = 0;
  int mealtime;
  int starvecount;
  boolean hungry;
  boolean isDead = false;
 

  //how do i grow the feesh's joint based on meals?
  //how do i kill it?

  float record ;
  Particle eat = null;

  Feesh(float _x, float _y, int _numJ, float _r, float _g, float _b) {
    x=_x;
    y=_y;
    r=_r;
    g=_g;
    b=_b;
    meals=0;
    
    starvecount=0;
    mealtime = int(random(300, 700));
    numJoints = _numJ;
    headColor = color(r, g, b);
    chewing = false; 
    bobs = new ArrayList<Bob>();

    springs = new ArrayList<Kspring>();
    Bob b = new Bob(x, y, 0.99, headColor);
    mouth = b;
    bobs.add(b);


    for (int i = 1; i < numJoints; i++) {
      springs.add( new Kspring(7));
      bobs.add(new Bob(x, y+i*10, .8, headColor));
    }
  }

  void run() {
    float offset =0;
    PVector gravity = new PVector(0, 0.5);

    mouth.displayHead();
    mouth.update();
    mouth.wander();
    mealtimer ++;
    
    for (int i =1; i<bobs.size(); i++) {
      offset+=i;
      Bob b = bobs.get(i);
      Bob a = bobs.get(i-1);
      Kspring s = springs.get(i-1);
      b.applyForce(gravity);
      s.connect(b, a);
      s.constrainLength(b, a, 0, 15);
      b.update();
      s.displayLine(b, a); 
      b.display(offset);
    }
  }


  void eat() {

    if (mealtimer>= mealtime) {
      hungry = true;
      starvecount++;
      if (starvecount == 500) {
        Bob b = bobs.get(bobs.size()-1);
        Kspring s = springs.get(springs.size()-1);
        springs.remove(s);
        bobs.remove(b);
        mouth.maxspeed-=0.1;
        mouth.maxforce-=0.1;
        starvecount=0;
      }
      if (bobs.size()==1 || bobs.size()==10) {
        isDead = true;
      }



    } 
    record = 1000;
    for (Shramp s : shramps) {
      PVector loc = new PVector(s.head.x, s.head.y);

      float d = PVector.dist(loc, mouth.location);

      if (hungry == true) {
        if (d <1000 && d <record && s.head.edible ) {
          record = d;
          //println(record);
          eat = s.head;
          if (eat != null) {
            PVector food = loc;

            mouth.seek(food);
            mouth.headColor = color(255, 0, 255, 200);
            // if the food is in range, it gets eaten/deleted
            if (d<20) {
              chewing = true;
              s.isDead = true;
              record =1000;
              meals++;
            

              if (meals == 5) {
                mouth.maxspeed+=.5;
                mouth.maxforce+=.5;
                Bob a = bobs.get(bobs.size()-1);
                Bob b = new Bob(a.x, a.y, 0.99, headColor);

                bobs.add(b);
                springs.add(new Kspring(7));
                meals =0;
                
              }
              

            }
          }
        }
      }
      if (hungry == false) {
        mouth.headColor = color(r, g, b);
        starvecount =0;
        //mouth.wander();
      }
      if (chewing == true) {
        mouth.chew();
        hungry = false;
        mealtimer =0;

        counter++;
        if (counter== 3000) {
          chewing = false;
          counter = 0;
        }
      }
    }
  }
}


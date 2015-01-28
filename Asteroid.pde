int puntos;
ArrayList<Balas> piupiu;
boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;
Nave vingala;
import gifAnimation.*;    // import the gifAnimation library
Gif candy; 

void setup() {
  
  candy = new Gif(this, "Candy2.gif");
  candy.play();  
  
  size(800, 600);
  noFill();
  frameRate(60);
  colorMode(HSB);
  
  puntos = 0;
  piupiu = new ArrayList<Balas>();
  vingala = new Nave();
   
}

void draw() {
   
  background(0);
   
  vingala.display();
  vingala.embalancia();
   
  for (int j = 0; j < piupiu.size(); j++){
    Balas piu = piupiu.get(j);
    piu.offScreen(j);
    piu.display();
    piu.embalancia();
  }
   
  /*textSize(15);
  fill(100, 100, 100);
  text("Puntos:" + puntos, 5, 40);*/
   
  if (keyup == true) vingala.acceleracion();
  if (keyleft == true) vingala.r -= 0.1;
  if (keyright == true) vingala.r += 0.1;
  vingala.v*=0.98;
}
 
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) keyup = true;
    if (keyCode == LEFT) keyleft = true;
    if (keyCode == RIGHT) keyright = true;
  }
  if (key == ' ') vingala.disparar();
}
 
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) keyup = false;
    if (keyCode == LEFT) keyleft = false;
    if (keyCode == RIGHT) keyright = false;
  }
}

class Balas extends Object {
  Balas(float x, float y, float a, float r) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.v = 20;
    this.r = r;
    this.w = 0;
    this.s = 4;
  }
 
  void show() {
    noFill();
    stroke(0, 255, 255);
    strokeWeight(5);
    rotate(r);
    beginShape();
    vertex(0, 4);
    vertex(0, -4);
    endShape();
    rotate(-r);
  }
 
  void offScreen(int j) {
    if (x > width-v || x < 0+v || y > height-v || y < 0+v) piupiu.remove(j);
  }
}
abstract class Object {
  float x, y, a, v, r, w, s;
 
  void embalancia() {
    r += w;
    x += cos(a)*v;
    y += sin(a)*v;
     
    if (x<0) {
      x += width;
      y = height-y;
    }
    if (x>width) {
      x -= width;
      y = height-y;
    }
    if (y<0) {
      y += height;
      x = width-x;
    }
    if (y>height) {
      y -= height;
      x = width-x;
    }
  }
 
  void show() {
  }
 
  void display() {
    translate(x, y);
    show();
    translate(-x, -y);
 
    if (x < 1.25*s) {
      translate(x+width, height-y);
      show();
      translate(-x-width, y-height);
    }
 
    if (x > width-1.25*s) {
      translate(x-width, height-y);
      show();
      translate(-x+width, y-height);
    }
 
    if (y < 1.25*s) {
      translate(width+x, y+height);
      show();
      translate(x-width, -y-height);
    }
 
    if (y > height-1.25*s) {
      translate(width-x, y-height);
      show();
      translate(x-width, -y+height);
    }
  }
}
class Nave extends Object {
  Nave() {
    this.lanzar();
  }

  void show() {
    noFill();
    stroke(180, 255, 255);
    strokeWeight(1);
    rotate(r);
    imageMode(CENTER);
    image(candy,0,-30,candy.width/1.5,candy.height/1.5);
    /*beginShape();
    vertex(0, 14);
    vertex(6, -14);
    vertex(-6, -14);
    vertex(0, 14);
    endShape();*/
    rotate(-r);
  }
   
  void lanzar(){
    this.x = width/2;
    this.y = height/2;
    this.a = 0;
    this.v = 0;
    this.r = radians(180);
    this.w = 0;
    this.s = 12;
  }
   
  void acceleracion() {
    float xt = cos(a)*v+cos(r+PI/2)*.1;
    float yt = sin(a)*v+sin(r+PI/2)*.1;
    v=sqrt(sq(yt)+sq(xt));
    a=atan2(yt, xt);
  }
 
  void disparar() {
    if(piupiu.size() < 8){
      piupiu.add(new Balas(x, y, r+PI/2, r));
    }
  }
}

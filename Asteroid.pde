int puntos, dividePiedras;
ArrayList<Balas> piupiu;
ArrayList<Asteroides> piedras;
Nave vingala;

import gifAnimation.*;    // Libreria gifAnimation
Gif candy; 

boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;




void setup() {
  
  candy = new Gif(this, "Candy2.gif");
  candy.play();  
  
  size(800, 800);
  noFill();
  frameRate(60);
  colorMode(HSB);
  
  puntos = 0;
  dividePiedras=0;
  
  piedras = new ArrayList<Asteroides>();
  for (int i = 0; i < 1; i++) {
    piedras.add(new Asteroides(random(0, width), 0, random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
    piedras.add(new Asteroides(random(0, width), height, random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
    piedras.add(new Asteroides(0, random(0, height), random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
    piedras.add(new Asteroides(width, random(0, height), random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
  }
  piupiu = new ArrayList<Balas>();
  vingala = new Nave();
  

}





void draw() {
   
  background(0);
   
  vingala.display();
  vingala.embalancia();
  
  for (int i = 0; i < piedras.size(); i++) {
    Asteroides piedra = piedras.get(i);
    piedra.display();
    piedra.embalancia();
     
    if(dist(piedra.x, piedra.y, vingala.x, vingala.y) < piedra.s+vingala.s){
      textSize(64);
      fill(255);
      text("OMAIGA", width/2-160, height/2);
      textSize(32);
      text("Presiona R para reintentar...", width/2-160, height/2+32);
      noLoop();
    }
     
    for (int j = 0; j < piupiu.size(); j++){
      Balas piu = piupiu.get(j);
      piedra.colision(piu, i, j);
    }
  }
   
  for (int j = 0; j < piupiu.size(); j++){
    Balas piu = piupiu.get(j);
    piu.offScreen(j);
    piu.display();
    piu.embalancia();
  }
   
  textSize(15);
  fill(100, 100, 100);
  text("Puntos:" + puntos, 5, 40);
   
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
  if (key == 'r'){
    piedras.clear();
    piupiu.clear();
    vingala.lanzar();
    puntos = 0;
    dividePiedras = 0;
    for (int i = 0; i < 1; i++) {
      piedras.add(new Asteroides(random(0, width), 0, random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
      piedras.add(new Asteroides(random(0, width), height, random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
      piedras.add(new Asteroides(0, random(0, height), random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
      piedras.add(new Asteroides(width, random(0, height), random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
    }
    loop();
  }
}
 
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) keyup = false;
    if (keyCode == LEFT) keyleft = false;
    if (keyCode == RIGHT) keyright = false;
  }
}

class Asteroides extends Object {
  float[] vertx = new float[16];
  float[] verty = new float[16];
  Asteroides(float x, float y, float a, float v, float w, float s) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.v = v;
    this.r = 0;
    this.w = w;
    this.s = s;
    for (int i = 0; i < 16; i++) {
      vertx[i] = sin(i*PI/8)*(s + random(-s/4, s/4));
      verty[i] = cos(i*PI/8)*(s + random(-s/4, s/4));
    }
  }
 
  void show() {
    noFill();
    stroke(255);
    strokeWeight(2);
    rotate(r);
    beginShape();
    for (int i = 0; i < 16; i++) {
      vertex(vertx[i], verty[i]);
    }
    vertex(vertx[0], verty[0]);
    endShape();
    rotate(-r);
  }
 
  void colision(Object thing, int i, int j) {
    if (dist(this.x, this.y, thing.x, thing.y) < this.s+thing.s ||
        dist(this.x+width, height-this.y, thing.x, thing.y) < this.s+thing.s ||
        dist(this.x-width, height-this.y, thing.x, thing.y) < this.s+thing.s ||
        dist(width-this.x, this.y+height, thing.x, thing.y) < this.s+thing.s ||
        dist(width-this.x, this.y-height, thing.x, thing.y) < this.s+thing.s) {
      puntos++;
      piupiu.remove(j);
      if (s>4){
        piedras.add(new Asteroides(x, y, a-PI/8, v*2, w*2, s/2));
        piedras.add(new Asteroides(x, y, a+PI/8, v*2, w*2, s/2));
      }
      dividePiedras++;
      if(dividePiedras == 4){
        dividePiedras = 0;
        piedras.add(new Asteroides(vingala.x+random(128, width-128), vingala.y+random(128, height-128), random(-PI, PI), random(0.4, 0.8), random(-PI/100, PI/100), 32));
      }
      piedras.remove(i);
    }
  }
}



class Balas extends Object {
  Balas(float x, float y, float a, float r) {
    this.x = x;
    this.y = y;
    this.a = a;
    this.v = 15;
    this.r = r;
    this.w = 0;
    this.s = 4;
  }
 
  void show() {
    noFill();
    stroke(0, 255, 255);
    strokeWeight(2);
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
    //strokeWeight(1);
    rotate(r);
    imageMode(CENTER);
    image(candy,0,-30,candy.width/2,candy.height/2);
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

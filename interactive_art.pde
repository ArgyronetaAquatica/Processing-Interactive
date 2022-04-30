void setup() {
 size (600,600); 
 colorMode(HSB,360,100,100);
 background(0);//represents emptiness
}

int rad = 200;//radius of circular region

void draw() {
  if (mousePressed) {
    float dist = dist(mouseX,mouseY,300,300);//distance from center of canvas
    if (dist>rad) {//if mouse pressed outside circle
      //maps colors: farther from origin = red, closer = blue
      float hue1 = map(dist,rad,400,240,360);
      //drawing my shape pattern where the mouse is pressed
      pushMatrix();
      translate(mouseX,mouseY);
      pattern1(int(dist),int(hue1));
      popMatrix();
    } else {//if mouse pressed inside circle
      //black stroke
      //farther from origin = red, closer = orange
      stroke(0,0,0);
      float hue2 = map(dist,rad,0,0,30);
      //draw shape 2 pattern at mouse pressed
      pushMatrix();
      translate(mouseX,mouseY);
      pattern2(int(dist),int(hue2),false);
      popMatrix();
    }
  }
}

//recursive pattern for shape1
void pattern1(int dist, int hue) {
  //scale becomes len in shape function
  //gets bigger around the edges of canvas
  float scale = map(dist,rad,340,3,45);
  if(scale<=3) {return;}//reaches minimum size
  //shape color
  //if hue goes over 360 it starts back at zero, so we get nice yellows
  //same for stroke, pushes hue slightly further along color wheel
  color col = color(hue%360,100,100);
  stroke((hue+20)%360,100,100);
  PShape fig = shape1(scale,col);
  //use 8 PShapes rotated around their corners to make a flower pattern
  for (int i = 0; i < 8; i++) {
    pushMatrix();
    rotate(radians(45*i));
    shape(fig,0,0);
    popMatrix();
  }
  //decrease size, increase hue
  pattern1(int(dist*0.8),hue+15);
}

//pattern for shape2; tilt is used to keep track of iterations
void pattern2(int dist, int hue, boolean tilt) {
  /*prevents problems where dist doesn't increment properly
  due to float-int conversions*/
  if(dist<2) {dist=2;}
  if(dist>=rad) {return;}//reaches max size
  //gets bigger around center
  float scale = map(dist,rad,0,3,45);
  color col;
  //hue reaches yellow and then starts decreasing saturation
  //this way it turns white instead of green, which looks better
  if (hue<60) {col = color(hue,100,100);}
  else {col = color(60,160-hue,100);}
  PShape fig = shape2(scale,col);
  pushMatrix();
  //the angle of pattern2 is slightly offset every second iteration
  if(tilt==true) {rotate(radians(45));}
  fill(0);
  //putting a black circle behind my shape for effect
  ellipse(0,0,scale*2,scale*2);
  //creating a pattern from 4 PShapes
  for (int i = 0; i < 4; i++) {
    pushMatrix();
    rotate(radians(90*i));
    shape(fig,0,0);
    popMatrix();
  }
  popMatrix();
  //increase size and hue, negate tilt
  pattern2(int(dist*1.5),hue+15,!tilt);
}

//shape 1
PShape shape1(float len, color col) {
  PShape s = createShape();
  s.beginShape();
  //converted from a 20X20 grid
  s.vertex(0,0);
  s.vertex(0,0.15*len);
  s.vertex(0.1*len,0.3*len);
  s.vertex(0.3*len,0.4*len);
  s.vertex(0.55*len,0.4*len);
  s.vertex(0.85*len,0.3*len);
  s.vertex(0.5*len,-0.05*len);
  s.vertex(0.3*len,0.1*len);
  s.vertex(0.15*len,0.1*len);
  s.vertex(0.05*len,0.05*len);
  s.endShape(CLOSE);
  s.setFill(col);
  return s;
}

//shape 2
PShape shape2(float len, color col) {
  PShape s = createShape();
  s.beginShape();
  //converted from a 5X5 grid
  s.vertex(0,0);
  s.vertex(0.4*len,0);
  s.vertex(0.6*len,0.2*len);
  s.vertex(len,0);
  s.vertex(0.8*len,0.6*len);
  s.vertex(0.4*len,0.4*len);
  s.vertex(0.6*len,0.8*len);
  s.vertex(0,len);
  s.vertex(0.2*len,0.6*len);
  s.vertex(0,0.4*len);
  s.endShape(CLOSE);
  s.setFill(col);
  return s;
}

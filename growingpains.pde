// Adapted from The Processing HandBook (30 - Dynamic Drawing Example 18)
void setup() {
  background(255);
  size(600,600);
  for (int i = 0; i < numLines; i++) {
    lines[i] = new MovingLine();
  }
  smooth();
}

int numLines = 1000;
int moveFrame = 200; // number of frames after drawing that frame that movement starts
boolean pause = false;
color rand = randomColor();
int points = int(random(1, 4));
int currentLine = 0;
int drawClr;
MovingLine[] lines = new MovingLine[numLines];
color[] clrs = { color(231, 71, 74), color(255, 209, 102), color(153, 194, 77), 
                color(4, 139, 168), color(147, 129, 255) };

void draw() {
  for (int i = 0; i < currentLine; i++) {
     lines[i].center();
  }
  if (!pause) {
    drawButtons();
  } else {
    clearButtons();
  } 
}

// chooses a random color
color randomColor() {
  int light = 0; // can change
  return color(min(random(255) + light, 255), min(random(255) + light, 255), min(random(255) + light, 255));
}

float centerx = random(40, width - 20);
float centery = random(20, height - 20);
      
// draws lines when mouse is dragged
void mouseDragged() {
  lines[currentLine].clr = clrs[drawClr]; 
  if (currentLine % points == 0) { // generates random center point for line
      centerx = random(40, width - 20); 
      centery = random(20, height - 20); 
   }
  lines[currentLine].setPosition(mouseX, mouseY, pmouseX, pmouseY, centerx, centery);
  if (currentLine < numLines - 1) {
    currentLine++;
  }
}

// draws the color buttons on the lefthand side
void drawButtons() {
  stroke(0);
  strokeWeight(1);
  fill(231, 71, 74);
  circle(20, 20, 15); // red
  fill(255, 209, 102);
  circle(20, 40, 15); // yellow
  fill(153, 194, 77);
  circle(20, 60, 15); // green
  fill(4, 139, 168);
  circle(20, 80, 15); // blue
  fill(147, 129, 255);
  circle(20, 100, 15); // purple
}

// clears the buttons on the lefthand side and replaces w the color palette 
void clearButtons() {
  noStroke();
  fill(255);
  rect(0, 0, 40, 210);
  fill(clrs[drawClr]);
  circle(20, 20, 15); // main color
  fill(lerpColor(clrs[drawClr], rand, 0.75));
  circle(20, 40, 15); // random color
  fill(0);
  circle(20, 60, 15); // black
  
}

void keyPressed() {
  if (key == ENTER) {
     pause = true;
     clearButtons();
     save("1.tif");
  }
}

// changes color or selects the "pause" button
void mouseClicked() {
  if (dist(mouseX, mouseY, 20, 20) < 16) { // red 
    drawClr = 0;
  }
  if (dist(mouseX, mouseY, 20, 40) < 16) { // yellow 
    drawClr = 1;
  }
  if (dist(mouseX, mouseY, 20, 60) < 16) { // green
    drawClr = 2;
  }
  if (dist(mouseX, mouseY, 20, 80) < 16) { // blue
    drawClr = 3; 
  }
  if (dist(mouseX, mouseY, 20, 100) < 16) { // purple
    drawClr = 4;
  }
}


class MovingLine {
  float x1, y1, x2, y2;
  color clr;
  color[] colors = {rand, color(0)};
  color lerp = colors[int(random(2))];
  float amt = 1.0;
  float speed = random(2, 5); // so that the strokes move toward their centers at varying speeds
  int firstFrame;
  float radius = random(3,10);
  float centerX;
  float centerY;
  
  // from Dynamic Drawing
  void setPosition(float x, float y, float px, float py, float cx, float cy) {
    x1 = x;
    y1 = y;
    x2 = px;
    y2 = py;
    firstFrame = frameCount; // ADDED
    centerX = cx + random(5); // ADDED
    centerY = cy + random(5); // ADDED
   }
  
  // pulls brush strokes toward center that has been chosen for ant
  void center() {
    if (frameCount - firstFrame > moveFrame) { // only runs 200 frames after line was drawn
      x1 = lerp(x1, centerX, random(0.001) * speed); 
      y1 = lerp(y1, centerY, random(0.001) * speed); 
      x2 = lerp(x2, centerX, random(0.001) * speed); 
      y2 = lerp(y2, centerY, random(0.001) * speed);
      amt += 1;
    }
    stroke(darkenColor());
    strokeWeight(radius);
    float draw = random(1);
    if (draw <= 0.2) {
      line(x1, y1, x2, y2);
    }
  }
  
  // causes color to fade to black
  color darkenColor() { 
      if (frameCount - firstFrame > moveFrame) {
        clr = lerpColor(clr, lerp, random(amt/100000));
      }
    return clr; 
  }
}

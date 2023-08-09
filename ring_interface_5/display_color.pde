//this is the color wheel to select RGB values
class DisplayColor {
  int x, y, xSize, ySize, cursorX, cursorY;
  float xHalf;
  float colorMag;
  PGraphics colorWheel;
  color selectedColor;
  
  DisplayColor(int _x, int _y, int _xSize, int _ySize) {
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
    xHalf = xSize * .5;
    selectedColor = color(150);

    colorWheel = createGraphics(xSize, xSize);
    colorWheel.beginDraw();
    colorWheel.background(0);
    float maxVal = 2*PI;
    colorWheel.colorMode(HSB, maxVal);
    colorWheel.strokeWeight(2);
    float inc = .001;
    colorWheel.translate(xHalf, xHalf);
    for (float i = 0; i < maxVal; i += inc) {
      colorWheel.stroke(i, maxVal, maxVal, PI);
      colorWheel.rotate(inc);
      colorWheel.line(0, 0, xHalf - 5, 0);
    }
    //white
    float scale = 1.8;
    int whiteMax = 50;
    colorWheel.colorMode(RGB, 255);
    for (int i = 1; i < whiteMax; i++) {
      colorWheel.noStroke();
      colorWheel.fill(255, whiteMax - 20 - i/scale);
      colorWheel.ellipse(0, 0, scale * i, scale * i);
    }

    //black vignette
    colorWheel.noFill();
    int blackMax = 35;
    for (int i = 0; i < blackMax; i ++) {
      colorWheel.strokeWeight(i * 2);
      colorWheel.stroke(0, blackMax+1-i);
      colorWheel.ellipse(0, 0, xSize, xSize);
    }
    colorWheel.endDraw();
  }

  void display() {
    strokeWeight(2);
    stroke(0);
    image(colorWheel, x, y);
    cursorIcon();
  }

  void update() {
    if (mouseX > x && mouseX < x + xSize && mouseY > y && mouseY < y+ySize) {
      selectedColor = get(mouseX, mouseY);
      cursorUpdate();
      colorInfo();
      cursorIcon();
      colorRect();
    }
  }

  void colorInput() {
    float red = redFader.faderAmt;
    float green = greenFader.faderAmt;
    float blue = blueFader.faderAmt;
    selectedColor = color(red * 255, green * 255, blue * 255);
  }
 
  void colorInfo() {
    float red = red(selectedColor);
    float green = green(selectedColor);
    float blue = blue(selectedColor);
    rInput.value = str(int(red));
    gInput.value = str(int(green));
    bInput.value = str(int(blue));
    redFader.faderAmt= red / 255;
    greenFader.faderAmt = green / 255;
    blueFader.faderAmt = blue / 255;
  }

  void cursorUpdate() {
    cursorX = mouseX;
    cursorY = mouseY;
  }

  void cursorIcon() {
    colorMode(RGB);
    float lineLength = 10;
    float circleSize = 4;
    strokeWeight(1);
    stroke(0);
    noFill();
    line(cursorX, cursorY - lineLength / 2, cursorX, cursorY - circleSize / 2);
    line(cursorX, cursorY + lineLength / 2, cursorX, cursorY + circleSize / 2);
    line(cursorX - lineLength / 2, cursorY, cursorX - circleSize / 2, cursorY);
    line(cursorX + lineLength / 2, cursorY, cursorX + circleSize / 2, cursorY);
    ellipse(cursorX, cursorY, circleSize, circleSize);
  }

  void colorRect() {
    fill(selectedColor);
    strokeWeight(2);
    stroke(0);
    rect(x + 1, y + xSize, xSize-3, xSize * .5);
  }
}

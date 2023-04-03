//faders to select RGBWwCw values
void faderSetup() {
  redFader = new Fader(color(255, 0, 0), 50, 50);
  faders.add(redFader);
  greenFader = new Fader(color(0, 255, 0), 100, 50);
  faders.add(greenFader);
  blueFader = new Fader(color(0, 0, 255), 150, 50);
  faders.add(blueFader);
  wwFader = new Fader(color(255, 240, 180), 200, 50);
  faders.add(wwFader);
  cwFader = new Fader(color(255, 255, 255), 250, 50);
  faders.add(cwFader);
}

void fadersGetValues() {
  for (ColorBox c : colorBoxes) {
    int index = colorBoxes.indexOf(c);
    boolean range = rInput.range;
    if (index % 2 == 0) {
      Fader f = faders.get(floor(index/2));
      if (!range) {
      f.faderAmt = float(c.value) / 255;
      }
      else {
      f.faderMax = float(c.value) / 255;
      }
    }
    else {
      Fader f = faders.get(floor(index-1)/2);
      f.faderMin = float(c.value) / 255;
    }
  }
}

class Fader {
  color col; 
  int x, y;
  float faderAmt = .5;
  float faderMax = 1;
  float faderMin = 0;
  int xSize = 35;
  float ySize = 150;
  //ranges refers to min max values for a gyroscope
  boolean ranges = false;
  Fader(color _col, int _x, int _y) {
    col = _col;
    x = _x;
    y = _y;
  }
  void update() {
    if (mouseX > x && mouseX < x + xSize && mouseY > y && mouseY < y+ySize) {
      if (!ranges) {
        faderAmt = 1 - (mouseY-y)/ySize;
        displayColor.colorInput();
      } else {
        if (mouseX < x + xSize * .5) {
          faderMin = 1 - (mouseY-y)/ySize;
        } else if (mouseX > x + xSize * .5) {
          faderMax =1 - (mouseY-y)/ySize;
        }
      }
      inputsGetVals();
    }
    ranges = (gyroSwitch.state == 0) ? false : true;
  }
  void display() {
    stroke(50);
    strokeWeight(3);
    fill(0);
    rect(x, y, xSize, ySize);
    fill(col);
    if (!ranges) {
      rect(x, y + ySize, xSize, - (faderAmt * ySize));
    } else {
      rect(x, y + ySize, xSize * .5, - (faderMin * ySize));
      rect(x + xSize * .5, y + ySize, xSize *.5, -(faderMax * ySize));
    }
  }
}

//input fields for color, time, and cue index
void inputsSetup() {
  secsInput = new SecsBox(400, 350, 75, 25);
  cueIndex = new CueIndex(redFader.x, height - 30, 50, 25);

  rInput = new ColorBox(redFader.x, redFader.y + redFader.ySize + 5, redFader.xSize, 25, true);
  colorBoxes.add(rInput);
  rInputMin = new ColorBox(redFader.x, rInput.y + rInput.ySize + 5, redFader.xSize, 25, false);
  colorBoxes.add(rInputMin);

  gInput = new ColorBox(greenFader.x, greenFader.y + greenFader.ySize + 5, greenFader.xSize, 25, true);
  colorBoxes.add(gInput);
  gInputMin = new ColorBox(greenFader.x, gInput.y + gInput.ySize + 5, greenFader.xSize, 25, false);
  colorBoxes.add(gInputMin);

  bInput = new ColorBox(blueFader.x, blueFader.y + blueFader.ySize + 5, blueFader.xSize, 25, true);
  colorBoxes.add(bInput);
  bInputMin = new ColorBox(blueFader.x, bInput.y + bInput.ySize + 5, blueFader.xSize, 25, false);
  colorBoxes.add(bInputMin);

  wwInput = new ColorBox(wwFader.x, wwFader.y + wwFader.ySize + 5, wwFader.xSize, 25, true);
  colorBoxes.add(wwInput);
  wwInputMin = new ColorBox(wwFader.x, wwInput.y + wwInput.ySize + 5, wwFader.xSize, 25, false);
  colorBoxes.add(wwInputMin);

  cwInput = new ColorBox(cwFader.x, cwFader.y + cwFader.ySize + 5, cwFader.xSize, 25, true);
  colorBoxes.add(cwInput);
  cwInputMin = new ColorBox(cwFader.x, cwInput.y + cwInput.ySize + 5, cwFader.xSize, 25, false);
  colorBoxes.add(cwInputMin);
}

void inputsGetVals() {
  for (Fader f : faders) {
    float fadVal = f.faderAmt;
    float fadMax = f.faderMax;
    float fadMin = f.faderMin;
    int index = faders.indexOf(f);
    boolean range = rInput.range;
    ColorBox c = colorBoxes.get(index * 2);
    ColorBox c2 = colorBoxes.get(index * 2 +1);
    if (!range) {
      c.value = String.valueOf(int(fadVal * 255));
    } else {
      c.value = String.valueOf(int(fadMax * 255));
    }
    c2.value = String.valueOf(int(fadMin * 255));
  }
}

class InputBox {
  float x, y, xSize, ySize;
  color high = color(255, 255, 100);
  color notHigh = color(255);
  color backColor = notHigh;
  boolean listening = false;
  String value = "";
  InputBox(float _x, float _y, float _xSize, float _ySize) {
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
  }
  void update() {
    backColor = (listening) ?
      high
      : notHigh;
    if (mousePressed) {
      if (mouseX > x && mouseX < x + xSize
        && mouseY > y && mouseY< y + ySize) {
        listening = true;
      } else {
        listening = false;
      }
    }
  }
  void input() {
    if (listening) {
      if (value.length() < 5) {
        if (key >= '0' && key <= '9') value += key;
      }
      //backspace
      if (keyCode == 8) removeLastChar();
      //enter
      if (keyCode == 10) listening = false;
    }
  }

  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    fill(0);
    textAlign(LEFT, CENTER);
    text(value, x + 3, y - 2 + ySize / 2);
  }
  
  void removeLastChar() {
    value = (value == null || value.length() == 0)
      ? ""
      : value.substring(0, value.length() - 1);
  }
}

class SecsBox extends InputBox {
  SecsBox(float _x, float _y, float _xSize, float _ySize) {
    super(_x, _y, _xSize, _ySize);
  }
  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    textAlign(LEFT, BOTTOM);
    fill(0);
    textSize(15);
    text("Seconds", x + 3, y);
    textAlign(LEFT, CENTER);
    text(value, x + 3, y - 2 + ySize / 2);
  }
}

class ColorBox extends InputBox {
  boolean range = false;
  boolean topBox;
  ColorBox(float _x, float _y, float _xSize, float _ySize, boolean _topBox) {
    super(_x, _y, _xSize, _ySize);
    topBox = _topBox;
    value = "127";
  }

  void display() {
    if (topBox || range) {
      fill(backColor);
      strokeWeight(3);
      stroke(150);
      rect(x, y, xSize, ySize);
      fill(0);
      textAlign(LEFT, CENTER);
      text(value, x + 3, y - 2 + ySize / 2);
    }
  }

  void input() {
    if (listening) {
      if (value.length() < 3) {
        if (key >= '0' && key <= '9') value += key;
      }
      //backspace
      if (keyCode == 8) removeLastChar();
      //enter
      if (keyCode == 10) listening = false;
    }
    if (int(value) > 255) value = String.valueOf(255);
    fadersGetValues();
    displayColor.colorInput();
  }
}

class CueIndex extends InputBox {
  CueIndex(float _x, float _y, float _xSize, float _ySize) {
    super(_x, _y, _xSize, _ySize);
    value = "0";
  }
  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    textAlign(LEFT, BOTTOM);
    fill(0);
    textSize(15);
    text("Index", x, y);
    textAlign(LEFT, CENTER);
    text(value, x + 3, y - 2 + ySize / 2);
  }
  void indexUpdate(int inc) {
    int index = int(value);
    index += inc;
    if (index < 0) index = 0;
    value = str(index);
  }
  //hit enter, new value, jump to that cue index
}

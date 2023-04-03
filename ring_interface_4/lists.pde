//selects a particular color to be mapped to one of the 3 axes,
//this will be redesigned to map between RGBWwCw color values rather than a single color value
void listsSetup() {
  int x = 300;
  int y = 50;
  rollList = new List("Roll", x, y, 80, 120);
  lists.add(rollList);
  x += 100;
  pitchList = new List("Pitch", x, y, 80, 120);
  lists.add(pitchList);
  x += 100;
  yawList = new List("Yaw", x, y, 80, 120);
  lists.add(yawList);
}

class List {
  String name;
  float x, y, xSize, ySize;
  String l[] = {"off", "Red", "Green", "Blue", "Warm White", "Cold White"};
  ArrayList<Box> boxes = new ArrayList();
  int currentSelection;
  List(String _name, float _x, float _y, float _xSize, float _ySize) {
    name = _name;
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
    float yDivSize = ySize / l.length;
    for (int i = 0; i < l.length; i++) {
      Box b = new Box(l[i], x, y + yDivSize * i, xSize, yDivSize);
      boxes.add(b);
    }
    currentSelection = 0;
    boxes.get(currentSelection).selected = true;
  }
  void update() {
    for (Box b : boxes) {
      b.update();
    }
    if (mouseY > y && mouseY< y + ySize && mouseX > x && mouseX < x + xSize) {
      if (mousePressed) {
        mouseSelection();
      }
    }
  }

  void loadedValue() {
    for (Box b : boxes) {
      b.selected = false;
      if (currentSelection == boxes.indexOf(b))
      {
        b.selected = true;
      }
    }
  }

  void mouseSelection() {
    for (Box b : boxes) {
      b.selected = false;
      if (b.high) {
        b.selected = true;
        currentSelection = boxes.indexOf(b);
      }
    }
    for (List l : lists) {
      if (l.currentSelection == this.currentSelection && l.name != this.name) {
        l.currentSelection = 0;
        l.resetBoxes();
        l.boxes.get(0).selected = true;
      }
    }
  }
  void display() {
    fill(0);
    textSize(25);
    textAlign(LEFT, BOTTOM);
    text(lists.get(lists.indexOf(this)).name, x + 3, y - 3);
    for (Box b : boxes) {
      b.display();
    }
  }
  void resetBoxes() {
    for (Box b : boxes) {
      b.selected = false;
    }
  }
}

class Box {
  String tag;
  float x, y, xSize, ySize;
  color background, select, highlight, unselected;
  boolean high = false;
  boolean selected = false;
  Box(String _tag, float _x, float _y, float _xSize, float _ySize) {
    tag = _tag;
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
    unselected = color(0, 0, 150);
    background = unselected;
    select = color(200, 0, 200);
    highlight = color(50, 50, 255);
  }
  void update() {
    if (mouseY > y && mouseY< y + ySize && mouseX > x && mouseX < x + xSize) {
      high = true;
    } else {
      high = false;
    }
    if (selected) background = select;
    else if (high) background = highlight;
    else if (!selected || !high) background = unselected;
  }
  void display() {
    stroke(50);
    strokeWeight(2);
    fill(background);
    rect(x, y, xSize, ySize);
    textSize(10);
    fill(255);
    textAlign(LEFT, CENTER);
    text(tag, x + 3, y + ySize / 2);
  }
}

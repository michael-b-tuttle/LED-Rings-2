void rotatorsSetup() {
  roll = new Rotator(rollList.x + rollList.xSize / 2, rollList.y + rollList.ySize + 30, 50);
  rotators.add(roll);
  pitch = new Rotator(pitchList.x + pitchList.xSize /2, pitchList.y + pitchList.ySize + 30, 50);
  rotators.add(pitch);
  yaw = new Rotator(yawList.x + yawList.xSize / 2, yawList.y + yawList.ySize + 30, 50);
  rotators.add(yaw);
}

class Rotator {
  float x, y, diameter;
  float rotation = 0;
  Rotator(float _x, float _y, float _diameter) {
    x = _x;
    y = _y;
    diameter = _diameter;
  }
  void update(float _input) {
    float input = map(_input, 0, width, -TWO_PI, TWO_PI);
    rotation = input;
  }
  void display() {
    ellipseMode(CENTER);
    push();
    translate(x, y);
    rotate(rotation);
    stroke(50);
    strokeWeight(3);
    fill(255);
    ellipse(0, 0, diameter, diameter);
    fill(0);
    stroke(0);
    strokeWeight(1);
    arc(0, 0, 50, 50, 0, PI, CHORD);
    pop();
  }
}

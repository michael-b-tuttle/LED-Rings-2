void rotatorsSetup() {
  //roll = new Rotator(rollList.x + rollList.xSize / 2, rollList.y + rollList.ySize + 30, 50);
  //rotators.add(roll);
  //pitch = new Rotator(pitchList.x + pitchList.xSize /2, pitchList.y + pitchList.ySize + 30, 50);
  //rotators.add(pitch);
  //yaw = new Rotator(yawList.x + yawList.xSize / 2, yawList.y + yawList.ySize + 30, 50);
  //rotators.add(yaw);
  float diameter = 100;
  roll = new Rotator(350 , 50 + (diameter * .5), diameter);
  rotators.add(roll);
  pitch = new Rotator(roll.x + roll.diameter + 20, roll.y, diameter);
  rotators.add(pitch);
}

class Rotator {
  float x, y, diameter;
  float rotation = 0;
  float theta, pTheta;
  Rotator(float _x, float _y, float _diameter) {
    x = _x;
    y = _y;
    diameter = _diameter;
    theta = 0;
    pTheta = 0;
  }
  //void update(float _input) {
  //  float input = map(_input, 0, width, -TWO_PI, TWO_PI);
  //  rotation = input;
  //}
    void update(float inputA, float inputB) {
    theta = atan2(inputA, inputB);
    rotation = pTheta;
    pTheta = pTheta + (theta - pTheta) * .1;
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
    arc(0, 0, diameter, diameter, 0, PI, CHORD);
    pop();
  }
}

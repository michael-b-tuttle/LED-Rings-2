//a timer which loads data for current cue and the time until next cue
class Countdown {
  float x, y, xSize, ySize;
  float countdownSecs = 0;
  //int prevSec = 0;
  float pMillis = 0;
  float cMillis = 0;
  float accumulator;
  color backColor = color(200);
  //boolean actionCalled = false;
  Countdown(float _x, float _y, float _xSize, float _ySize) {
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
  }
  void update(float _seconds) {
    countdownSecs = _seconds;
    cMillis = millis() * .001;
    pMillis = cMillis;
  }
 
  void calculate() {
    if (countdownSecs != 0) {
      accumulator = cMillis - pMillis;
      countdownSecs -= accumulator;
      pMillis = cMillis;
      cMillis = millis() * .001;
    }
    if (countdownSecs < 0) {
      countdownSecs = 0;
      cMillis = 0;
      pMillis = 0;
      accumulator = 0;
      if (player.isPlaying) {
        cueIndex.indexUpdate(1);
        player.nextCue();
      }
    }
  }
  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    textAlign(LEFT, BOTTOM);
    fill(0);
    textSize(15);
    text("Countdown", x + 3, y);
    textAlign(LEFT, TOP);
    text(englishNF.format(countdownSecs), x + 3, y + 3);
  }
}

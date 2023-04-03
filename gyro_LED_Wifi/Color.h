//receives value for each color channel, calculates that color with either gyroscope or timer
#ifndef COLOR_H
#define COLOR_H

class Color {
  public:
    float colVal;
    float input;
    float offSet;
    float colStart;
    int gyroSelect;
    float diff;
    Color () {
      input = 0;
      offSet = 0;
      gyroSelect = 0;
      colVal = 255;
      diff = 0;
    }
    void gyroInput() {
      if (gyro.active) {
        switch (gyroSelect) {
          case 0:
            input = 0;
            offSet = 0;
            break;
          case 1:
            input = gyro.roll;
            offSet = gyro.rOff;
            break;
          case 2:
            input = gyro.pitch;
            offSet = gyro.pOff;
            break;
          case 3:
            input = gyro.yaw;
            offSet = gyro.yOff;
            break;
        }
        colVal = 255 * gyro.normalizeAngle(input, offSet);
      }
    }
    void receiveColor(float dest) {
      float colDest = dest;
      diff = colDest - colVal;
      colStart = colVal;
    }
    void colorChange() {
      if (timer.counting) {
        colVal = colStart + diff * timer.amount;
      }
    }
};
#endif

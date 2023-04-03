//takes acceleration and gyroscope data to return position
//strangly, roll (0 -> 180), pitch (0 -> 90), yaw (0 -> 360)
//I want to normalize each data stream to 0. -> 1.
#ifndef GYRO_H
#define GYRO_H

class Gyro {
  private:
    float xAcc, yAcc, zAcc;
    float xGyro, yGyro, zGyro;
  public:
    float roll, pitch, yaw;
    float rOff, pOff, yOff;
    boolean active = false;
    boolean recalibrate = false;
    Gyro() {
      rOff = 0;
      pOff = 0;
      yOff = 0;
    }
    void reading() {
      //      if (active) {
      if (IMU.accelerationAvailable() &&
          IMU.gyroscopeAvailable()) {
        IMU.readAcceleration(xAcc, yAcc, zAcc);
        IMU.readGyroscope(xGyro, yGyro, zGyro);
        filter.updateIMU(xGyro, yGyro, zGyro, xAcc, yAcc, zAcc);
        roll = filter.getRoll();
        pitch = filter.getPitch();
//        pitch = pitch * 2;
        yaw = filter.getYaw();
//        yaw = yaw * .5;
      }
      //      }
    }
    void offSetCalculate() {
      if (recalibrate) {
        rOff = roll;
        pOff = pitch;
        yOff = yaw;
        recalibrate = false;
      }
    }
    float normalizeAngle(float degAngle, float offSet) {
      float rads = ((degAngle - offSet) / 180) * PI;
      float normAngle = abs(sin(rads));
      return normAngle;
    }
};

#endif

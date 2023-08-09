//takes acceleration and gyroscope data to return position
//strangly, roll (0 -> 180), pitch (0 -> 90), yaw (0 -> 360)
//I want to normalize each data stream to 0. -> 1.
#ifndef GYRO_H
#define GYRO_H

class Gyro {
  private:
    float xAcc, yAcc, zAcc = 0.0f;
    float xGyro, yGyro, zGyro = 0.0f;
  public:
    float roll, pitch, yaw = 0.0f;
    float rOff, pOff, yOff = 0.0f;
    boolean active = false;
    boolean recalibrate = false;
    Gyro() {
      rOff = 0;
      pOff = 0;
      yOff = 0;
      //      if (!IMU.begin()) {
      //        //    Serial.println("Failed to initialize IMU");
      //        while (true);
      //      }
    }
    void reading() {
      if (active) {
        //        if (IMU.accelerationAvailable() &&
        //            IMU.gyroscopeAvailable()) {
        if (IMU.accelerationAvailable()) {
          IMU.readAcceleration(xAcc, yAcc, zAcc);
          //          IMU.readGyroscope(xGyro, yGyro, zGyro);
          roll = xAcc;
          pitch = yAcc;
          yaw = zAcc;
//          roll = constrainNormal(xAcc);
//          pitch = constrainNormal(yAcc);
//          yaw = constrainNormal(zAcc);
          if (isnan(roll)) {
            Serial.println("restarting gyro");
            IMU.end();
            IMU.begin();
            delay(2000);
            return;
          }
//                    filter.updateIMU(xGyro, yGyro, zGyro, xAcc, yAcc, zAcc);
//                    roll = filter.getRoll();
//                    pitch = filter.getPitch();
          //        pitch = pitch * 2;
//                    yaw = filter.getYaw();
          //        yaw = yaw * .5;
        }
      }
    }
//    float constrainNormal(float val) {
//      float conVal = constrain(val, -1., 1.);
//      conVal = conVal * 1000;
//      float output = map(conVal, -1000, 1000, 0, 1000);
//      output = output / 1000;
//      return output;
//    }
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

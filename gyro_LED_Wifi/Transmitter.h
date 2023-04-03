//sends position data back to laptop
//this seems to crash the arduino's gyroscope after a minute or so. I can't figure out why
#ifndef TRANSMITTER_H
#define TRANSMITTER_H

class Transmitter {
  public:
    int interval = 1000;
    int lastMilli = 0;
    bool receivedFirstMessage = false;
    //    int availableMemory() {
    //      // Use 1024 with ATmega168
    //      int size = 2048;
    //      byte *buf;
    //      while ((buf = (byte *) malloc(--size)) == NULL);
    //      free(buf);
    //      return size;
    //    }
    /*
      void sendData() {
      if (receivedFirstMessage) {
        if (millis() - lastMilli > interval) {
          //          float r = gyro.normalizeAngle(gyro.roll, 0);
          //          float p = gyro.normalizeAngle(gyro.pitch, 0);
          //          float y = gyro.normalizeAngle(gyro.yaw, 0);
          float r = gyro.roll;
          float p = gyro.pitch;
          float y = gyro.yaw;
          if (isnan(r)) {
            Serial.println("not working!");
          }

          char posMessage[75];
          sprintf(posMessage, "r %f, p %f, y %f ", r, p, y);
          //Udp.beginPacket(Udp.remoteIP(), remotePort);
          //          Udp.beginPacket("192.168.1.4", 12000);
          //          Udp.write(posMessage);
          //          Udp.endPacket();
          //          free(posMessage);
          lastMilli = millis();
      //          Serial.print("position ");
          Serial.println(posMessage);
      //          Serial.println(r);

          //          Serial.print("memory ");
          // free RAM check for debugging. SRAM for ATmega328p = 2048Kb.
          // Serial.println(availableMemory());
        }
      }
      }
    */
    void sendData() {
      if (millis() - lastMilli > interval) {
        float r = gyro.roll;
        float p = gyro.pitch;
        float y = gyro.yaw;
        if (isnan(r)) {
          Serial.println("not working!");
        }
        lastMilli = millis();
        char posMessage[75];
        sprintf(posMessage, "r %f, p %f, y %f ", r, p, y);
        Serial.println(posMessage);
      }
      else {
        Serial.print("nope!");
      }
    }
};

#endif

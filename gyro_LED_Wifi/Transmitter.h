//sends position data back to laptop
#ifndef TRANSMITTER_H
#define TRANSMITTER_H

#include <Arduino_LSM6DSOX.h>

class Transmitter {
  public:
    int interval = 1000;
    int lastMilli = 0;
    bool receivedFirstMessage = false;

    void sendData() {
      if (receivedFirstMessage) {
        if (millis() - lastMilli > interval) {
          //          float r = gyro.normalizeAngle(gyro.roll, 0);
          //          float p = gyro.normalizeAngle(gyro.pitch, 0);
          //          float y = gyro.normalizeAngle(gyro.yaw, 0);
          float r = gyro.roll;
          float p = gyro.pitch;
          float y = gyro.yaw;
          char posMessage[75];
          sprintf(posMessage, "r %f, p %f, y %f ", r, p, y);
          IPAddress remoteIp = Udp.remoteIP();
          Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
          //          Udp.beginPacket("192.168.1.100", 12000);
          Udp.write(posMessage);
          Udp.endPacket();
          lastMilli = millis();
          Serial.print("r ");
          Serial.print("\t");
          Serial.print(r);
          Serial.print("p ");
          Serial.print("\t");
          Serial.print(p);
          Serial.print("y ");
          Serial.print("\t");
          Serial.println(y);
          //          Serial.println(posMessage);
        }
      }
    }

    void receiveMessage() {
      int packetSize = Udp.parsePacket();
      if (packetSize) {
        receivedFirstMessage = true;
        Serial.print("\nReceived packet of size ");
        Serial.println(packetSize);
        Serial.print("From ");
        IPAddress remoteIp = Udp.remoteIP();
        Serial.print(remoteIp);
        Serial.print(", port ");
        Serial.println(Udp.remotePort());
        // read the packet into packetBufffer
        int len = Udp.read(packetBuffer, packetSize);
        if (len > 0) {
          packetBuffer[len] = 0;
        }
        Serial.println("Contents:");
        Serial.println();
        Serial.println(packetBuffer);
        xmlEvent(packetBuffer, packetSize);
        Udp.beginPacket(Udp.remoteIP(), 12000);
        Udp.write(ReplyBuffer);
        Udp.endPacket();
        printData();
      }
    }
};

#endif

#include "Arduino_LSM6DSOX.h"
#include "MadgwickAHRS.h"
Madgwick filter;
#include <WiFiNINA.h>
#include <SPI.h>
#include <WiFiUdp.h>
WiFiUDP Udp;
#include "arduino_secrets.h"
#include <string.h>
#include "Gyro.h"
Gyro gyro;
#include "Timer.h"
Timer timer;
#include "Color.h"
Color none;
Color red;
Color green;
Color blue;
Color warmWhite;
Color coldWhite;
Color* colors[] = {&none, &red, &green, &blue, &warmWhite, &coldWhite};
const int redPin = 3;
const int greenPin = 5;
const int bluePin = 6;
const int wWhitePin = 11;
const int cWhitePin = 9;
#include "xmlParse.h"

const float sensorRate = 104.00;

#include "wifiSetup.h"
#include "Transmitter.h"
Transmitter transmitter;


void setup() {
  Serial.begin(9600);
  //  while (!Serial) {
  //    ;
  //  }
  pinMode(LEDR, OUTPUT);
  pinMode(LEDG, OUTPUT);
  pinMode(LEDB, OUTPUT);

  if (!IMU.begin()) {
    //    Serial.println("Failed to initialize IMU");
    while (true);
  }
  wifiSetup();
  printWifiStatus();
  Udp.begin(localPort);
//  filter.begin(sensorRate);
//  analogWrite(LEDG, 255);
//  analogWrite(LEDB, 255);
}

void loop() {
  gyro.reading();
  timer.calculate();
  transmitter.receiveMessage();

  for (int i = 0; i < 6; i ++) {
    colors[i]->gyroInput();
    colors[i]->colorChange();
  }

  if (timer.counting) {
    analogWrite(redPin, red.colVal);
    analogWrite(greenPin, green.colVal);
    analogWrite(bluePin, blue.colVal);
    analogWrite(wWhitePin, warmWhite.colVal);
    analogWrite(cWhitePin, coldWhite.colVal);
  }

  transmitter.sendData();

    analogWrite(LEDR, 255 - (abs(red.colVal*250)));
    analogWrite(LEDG, 255 - (abs(green.colVal*250)));
    analogWrite(LEDB, 255 - (abs(blue.colVal*250)));
//  analogWrite(LEDR, 255 - abs(gyro.roll * 255));
//  analogWrite(LEDG, 255 - abs(gyro.pitch * 255));
//  analogWrite(LEDB, 255 - abs(gyro.yaw * 255));
  delay(50);
}

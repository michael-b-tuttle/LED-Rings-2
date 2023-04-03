#include "Arduino_LSM6DSOX.h"
#include "MadgwickAHRS.h"
Madgwick filter;
#include <WiFiNINA.h>
#include <SPI.h>
#include <WiFiUdp.h>
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
Color *colors[] = {&none, &red, &green, &blue, &warmWhite, &coldWhite};
#include "xmlParse.h"

const float sensorRate = 104.00;

int status = WL_IDLE_STATUS;
char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;
unsigned int localPort = 6100;
char packetBuffer[1024];
char ReplyBuffer[] = "**************** acknowledged *******************";
WiFiUDP Udp;
#include "Transmitter.h"
Transmitter transmitter;

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ;
  }
  pinMode(LEDR, OUTPUT);
  pinMode(LEDG, OUTPUT);
  pinMode(LEDB, OUTPUT);

  wifiSetup();
  printWifiStatus();
  Udp.begin(localPort);
  filter.begin(sensorRate);
}

void loop() {
  gyro.reading();
  timer.calculate();
  receiveMessage();
  for (int i = 0; i < 6; i ++) {
    colors[i]->gyroInput();
    colors[i]->colorChange();
  }

  transmitter.sendData();

  //    printData();
  
  analogWrite(LEDR, 255 - red.colVal);
  analogWrite(LEDG, 255 - green.colVal);
  analogWrite(LEDB, 255 - blue.colVal);
  Serial.println("yes!");
  delay(10);
}

void printData() {
  Serial.print("r ");
  Serial.print(red.colVal);
  Serial.print(", g ");
  Serial.print(green.colVal);
  Serial.print(", b ");
  Serial.print(blue.colVal);
  Serial.print(", ww ");
  Serial.print(warmWhite.colVal);
  Serial.print(", cw ");
  Serial.println(coldWhite.colVal);

  /*
    Serial.print("r ");
    Serial.print(gyro.roll);
    Serial.print(", p ");
    Serial.print(gyro.pitch);
    Serial.print(", y ");
    Serial.println(gyro.yaw);
  */
}

void wifiSetup() {
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU");
    while (true);
  }
  if (WiFi.status() == WL_NO_MODULE) {
    Serial.println("Communication with WiFi module failed!");
    while (true);
  }
  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }
  while (status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    status = WiFi.begin(ssid, pass);
    delay(10000);
  }
  Serial.println("Connected to wifi");
}

void printWifiStatus() {
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  Serial.println("\nStarting connection to server...");
}

void receiveMessage() {
  int packetSize = Udp.parsePacket();
  if (packetSize) {
    transmitter.receivedFirstMessage = true;
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

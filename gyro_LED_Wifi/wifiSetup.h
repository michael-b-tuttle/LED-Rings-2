#ifndef WIFISETUP_H
#define WIFISETUP_H

int status = WL_IDLE_STATUS;
char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;
unsigned int localPort = 6100;
char packetBuffer[1024];
char ReplyBuffer[] = "**************** acknowledged *******************";

void wifiSetup() {
  if (WiFi.status() == WL_NO_MODULE) {
    while (true);
  }
  String fv = WiFi.firmwareVersion();
  if (fv < WIFI_FIRMWARE_LATEST_VERSION) {
    Serial.println("Please upgrade the firmware");
  }
  //Ring 2
//  WiFi.config(IPAddress(192, 168, 1, 152));
  WiFi.config(IPAddress(192, 168, 0, 152));
  while (status != WL_CONNECTED) {
    status = WiFi.begin(ssid, pass);
    delay(10000);
  }
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

  Serial.print("r ");
  Serial.print(gyro.roll);
  Serial.print(", p ");
  Serial.print(gyro.pitch);
  Serial.print(", y ");
  Serial.println(gyro.yaw);
}

#endif

//to parse incoming xml files
#ifndef XMLPARSE_H
#define XMLPARSE_H
#define MAX_STRING_LEN  20
// Setup vars
char tagStr[MAX_STRING_LEN] = "";
char dataStr[MAX_STRING_LEN] = "";
char tmpStr[MAX_STRING_LEN] = "";
char endTag[3] = {'<', '/', '\0'};
int len;

// Flags to differentiate XML tags from document elements (ie. data)
boolean tagFlag = false;
boolean dataFlag = false;

#include "stringFunctions.h"

// Process each char
void xmlEvent(char packBuffer[], int packSize) {
  char inChar;
  bool reset = true;
  for (int i = 0; i < packSize ; i ++) {

    inChar = packBuffer[i];

    if (inChar == '<') {
      addChar(inChar, tmpStr);
      tagFlag = true;
      dataFlag = false;
    }
    else if (inChar == '>') {
      addChar(inChar, tmpStr);

      if (tagFlag) {
        strncpy(tagStr, tmpStr, strlen(tmpStr) + 1);
      }

      // Clear tmp
      clearStr(tmpStr);

      tagFlag = false;
      dataFlag = true;

      //if char != nl
    } else if (inChar != 10) {
      if (tagFlag) {
        // Add tag char to string
        addChar(inChar, tmpStr);

        // Check for </XML> end tag, ignore it
        if (tagFlag && strcmp(tmpStr, endTag) == 0) {
          clearStr(tmpStr);
          tagFlag = false;
          dataFlag = false;
        }
      }

      if (dataFlag) {
        // Add data char to string
        addChar(inChar, dataStr);
      }
    }

    // If a nl, process the line
    if (inChar == 10 ) {
      std::string::size_type sz;
      if (matchTag("<red>")) {
        float redVal = std::stof (dataStr, &sz);
        redVal *= 255;
        red.receiveColor(redVal);
      }
      if (matchTag("<green>")) {
        float greenVal = std::stof (dataStr, &sz);
        greenVal *= 255;
        green.receiveColor(greenVal);
      }
      if (matchTag("<blue>")) {
        float blueVal = std::stof (dataStr, &sz);
        blueVal *= 255;
        blue.receiveColor(blueVal);
      }
      if (matchTag("<warmWhite>")) {
        float wwVal = std::stof (dataStr, &sz);
        wwVal *= 255;
        warmWhite.receiveColor(wwVal);
      }
      if (matchTag("<coldWhite>")) {
        float cwVal = std::stof (dataStr, &sz);
        cwVal *= 255;
        coldWhite.receiveColor(cwVal);
      }
      if (matchTag("<gyroActive>")) {
        int value = std::stoi(dataStr, &sz);
        if (value == 1) {
          gyro.active = true;
        }
        else if (value == 0) {
          gyro.active = false;
        }
      }
      if (reset) {
        for (int i = 0; i < 6; i ++) {
          colors[i]->gyroSelect = 0;
        }
        reset = false;
      }

      if (matchTag("<rollAssign>")) {
        int rollAssign = std::stoi (dataStr, &sz);
        colors[rollAssign]->gyroSelect = 1;
      }
      if (matchTag("<pitchAssign>")) {
        int pitchAssign = std::stoi (dataStr, &sz);
        colors[pitchAssign]->gyroSelect = 2;
      }
      if (matchTag("<yawAssign>")) {
        int yawAssign = std::stoi (dataStr, &sz);
        colors[yawAssign]->gyroSelect = 3;
      }

      if (matchTag("<time>")) {
        int timeMillis = std::stoi (dataStr, &sz);
        timer.start(timeMillis);
      }
      if (matchTag("<reconfig>")) {
        int value = std::stoi(dataStr, &sz);
        if (value == 1) {
          //gyro.recalibrate = true;
        }
        else if (value == 0) {
          //gyro.recalibrate = false;
        }
      }

      // Clear all strings
      clearStr(tmpStr);
      clearStr(tagStr);
      clearStr(dataStr);

      // Clear Flags
      tagFlag = false;
      dataFlag = false;
    }
  }
}
#endif

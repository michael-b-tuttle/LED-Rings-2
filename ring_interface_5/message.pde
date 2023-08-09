//an xml message sent to the arduino
class Message {
  XML document;
  //String ip       = "192.168.0.100";
  //ring 1
  String ip       = "192.168.0.151";
  //ring 2
  //String ip       = "192.168.1.152";
    //String ip       = "192.168.0.152";
  int port        = 6100;

  void sendMessage() {
    XML m = createXML();
    udp.send(m.format(0), ip, port);
    //maybe this isn't working because I've hard coded it to false...
    //reconfig.reset = false;
  }

  void sendGoal(XML _m) {
    XML m = _m;
    println("goal index ", m.getChild("index"));
    udp.send(m.format(0), ip, port);
  }

  XML createXML() {
    int index = int(cueIndex.value);
    XML xml;

    float red = redFader.faderAmt;
    float green = greenFader.faderAmt;
    float blue = blueFader.faderAmt;
    float ww = wwFader.faderAmt;
    float cw = cwFader.faderAmt;

    float rFaderMax = redFader.faderMax;
    float rFaderMin = redFader.faderMin;
    float gFaderMax = greenFader.faderMax;
    float gFaderMin = greenFader.faderMin;
    float bFaderMax = blueFader.faderMax;
    float bFaderMin = blueFader.faderMin;
    float wwFaderMax = wwFader.faderMax;
    float wwFaderMin = wwFader.faderMin;
    float cwFaderMax = cwFader.faderMax;
    float cwFaderMin = cwFader.faderMin;

    int gyro = gyroSwitch.state;
    //int roll = rollList.currentSelection;
    //int pitch = pitchList.currentSelection;
    //int yaw = yawList.currentSelection;
    int time = int(secsInput.value);
    time *= 1000;
    if (time < 1) time = 50;
    //boolean reset = ((Reconfig)reconfig).reset;
    xml = new XML("cue");
    xml.addChild("index");
    xml.getChild("index").setIntContent(index);

    xml.addChild("red").setFloatContent(red);
    xml.addChild("green").setFloatContent(green);
    xml.addChild("blue").setFloatContent(blue);
    xml.addChild("warmWhite").setFloatContent(ww);
    xml.addChild("coldWhite").setFloatContent(cw);

    xml.addChild("rFaderMin").setFloatContent(rFaderMin);
    xml.addChild("rFaderMax").setFloatContent(rFaderMax);
    xml.addChild("gFaderMin").setFloatContent(gFaderMin);
    xml.addChild("gFaderMax").setFloatContent(gFaderMax);
    xml.addChild("bFaderMin").setFloatContent(bFaderMin);
    xml.addChild("bFaderMax").setFloatContent(bFaderMax);
    xml.addChild("wwFaderMin").setFloatContent(wwFaderMin);
    xml.addChild("wwFaderMax").setFloatContent(wwFaderMax);
    xml.addChild("cwFaderMin").setFloatContent(cwFaderMin);
    xml.addChild("cwFaderMax").setFloatContent(cwFaderMax);

    xml.addChild("gyroActive").setIntContent(gyro);
    //xml.addChild("rollAssign").setIntContent(roll);
    //xml.addChild("pitchAssign").setIntContent(pitch);
    //xml.addChild("yawAssign").setIntContent(yaw);
    xml.addChild("time").setFloatContent(time);
    //xml.addChild("reconfig").setIntContent(int(reset)); //0 or 1
    //reconfig.reset = false;
    return xml;
  }
}

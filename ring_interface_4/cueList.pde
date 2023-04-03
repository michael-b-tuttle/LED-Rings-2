//a playlist of all cues and data held in a single cue
class CueList {
  XML loadedList, currList;
  XML tempMess;
  int currIndex;
  //it was necessary to map an xml file to this hashmap because the indices of the xml file were not consistant with my expectations
  HashMap<Integer, Integer> cueMap = new HashMap();
  CueList() {
  }
  void update() {
    currIndex = int(cueIndex.value);
    println("currIndex, update ", currIndex);
    if (cueList != null) {
      if (cueMap.containsKey(currIndex) == true) {
        int cueIndex = cueMap.get(currIndex);
        println("cue index: ", cueIndex);
        if (currList.getChild(cueIndex).hasChildren()) {
          int state = currList.getChild(cueIndex).getChild("gyroActive").getIntContent();
          gyroSwitch.state = state;
          for (Fader f : faders) {
            f.update();
          }
          for (ColorBox c : colorBoxes) {
            c.range = (gyroSwitch.state == 0) ? false : true;
          }

          float time = currList.getChild(cueIndex).getChild("time").getIntContent();
          int _time = int(time * .001);
          secsInput.value = str(_time);

          float red = currList.getChild(cueIndex).getChild("red").getFloatContent();
          redFader.faderAmt = red;
          float green = currList.getChild(cueIndex).getChild("green").getFloatContent();
          greenFader.faderAmt = green;
          float blue = currList.getChild(cueIndex).getChild("blue").getFloatContent();
          blueFader.faderAmt = blue;
          float wwhite = currList.getChild(cueIndex).getChild("warmWhite").getFloatContent();
          wwFader.faderAmt = wwhite;
          float cwhite = currList.getChild(cueIndex).getChild("coldWhite").getFloatContent();
          cwFader.faderAmt = cwhite;

          float rFaderMax = currList.getChild(cueIndex).getChild("rFaderMax").getFloatContent();
          redFader.faderMax = rFaderMax;
          float rFaderMin = currList.getChild(cueIndex).getChild("rFaderMin").getFloatContent();
          redFader.faderMin = rFaderMin;
          float gFaderMax = currList.getChild(cueIndex).getChild("gFaderMax").getFloatContent();
          greenFader.faderMax = gFaderMax;
          float gFaderMin = currList.getChild(cueIndex).getChild("gFaderMin").getFloatContent();
          greenFader.faderMin = gFaderMin;
          float bFaderMax = currList.getChild(cueIndex).getChild("bFaderMax").getFloatContent();
          blueFader.faderMax = bFaderMax;
          float bFaderMin = currList.getChild(cueIndex).getChild("bFaderMin").getFloatContent();
          blueFader.faderMin = bFaderMin;
          float wwFaderMax = currList.getChild(cueIndex).getChild("wwFaderMax").getFloatContent();
          wwFader.faderMax = wwFaderMax;
          float wwFaderMin = currList.getChild(cueIndex).getChild("wwFaderMin").getFloatContent();
          wwFader.faderMin = wwFaderMin;
          float cwFaderMax = currList.getChild(cueIndex).getChild("cwFaderMax").getFloatContent();
          cwFader.faderMax = cwFaderMax;
          float cwFaderMin = currList.getChild(cueIndex).getChild("cwFaderMin").getFloatContent();
          cwFader.faderMin = cwFaderMin;
          inputsGetVals();

          int rollVal = currList.getChild(cueIndex).getChild("rollAssign").getIntContent();
          rollList.currentSelection = rollVal;
          int pitchVal = currList.getChild(cueIndex).getChild("pitchAssign").getIntContent();
          pitchList.currentSelection = pitchVal;
          int yawVal = currList.getChild(cueIndex).getChild("yawAssign").getIntContent();
          yawList.currentSelection = yawVal;
          for (List l : lists) {
            l.loadedValue();
          }
          displayColor.colorInput();
        }
      } else {
        println("no cue");
      }
    }
    println();
  }

  void loadList(String path) {
    loadedList = loadXML(path);
    if (cueList != null) {
      currList = loadedList;

      xmlHashMapUpdate();
      println("xml indices, loadList ", cueMap);
    }
  }

  void copyCue() {
  }

  void pasteCue() {
  }

  void addCue() {
    tempMess = message.createXML();
    if (currList == null) {
      cueList.currList = new XML("scene");
    }
    deleteCue();
    currList.addChild(tempMess);
    xmlHashMapUpdate();
    println("indices addCue", cueMap);
  }

  void deleteCue() {
    println("deleted!");
    if (cueMap.containsKey(currIndex) == true) {
      int cueIndex = cueMap.get(currIndex);
      cueMap.remove(cueIndex);
      XML child = currList.getChild(cueIndex);
      currList.removeChild(child);
      xmlHashMapUpdate();
      println("indices deleteCue", cueMap);
    }
  }

  void xmlHashMapUpdate() {
    for (int i = 0; i < currList.getChildCount(); i ++) {
      if (currList.getChild(i).hasChildren()) {
        String xmlIndex = currList.getChild(i).getChild("index").getContent();
        cueMap.put(int(xmlIndex), i);
      }
    }
  }
}

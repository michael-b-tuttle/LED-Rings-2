//loads data for current cue, executes the countdown, loads next cue from playlist
class Player {
  boolean isPlaying = false;
  ArrayList<Integer> playList = new ArrayList();
  int playListIndex = 0;
  int playListMax;
  Player() {
  }

  void action() {
    isPlaying = !isPlaying;
    if (playList.size() == 0) {
      newPlayList();
    }
    if (cueList.currList != null) {
      message.sendMessage();
      goalCue();
      countdown.update(float(secsInput.value));
    }
    if (!isPlaying) {
      clear.action();
      playList.clear();
    }
  }
  void nextCue() {
    if (playList.contains(int(cueIndex.value))) {
      cueList.update();
      message.sendMessage();
      goalCue();
      countdown.update(int(secsInput.value));
    } else {
      stepper();
    }
  }
  //recursive
  void stepper() {
    if (int(cueIndex.value) <= playListMax) {
      cueIndex.indexUpdate(1);
      nextCue();
    } else {
      stopPlaying();
    }
  }
  void goalCue() {
    int tempIndex = playList.indexOf(int(cueIndex.value));
    tempIndex ++;
    //println("temp index, goal ", tempIndex);
    if (tempIndex < playList.size()) {
      int goalXMLindex = cueList.cueMap.get(tempIndex);
      XML m = cueList.currList.getChild(goalXMLindex);;
      message.sendGoal(m);
      //println("mapped ", mapped);
      //println("goal xml index ", goalXMLindex);
    }
  }
  void stopPlaying() {
    isPlaying = false;
    clear.action();
    println("stop");
  }
  void newPlayList() {
    playListMax = -1;
    playList.clear();
    for (Map.Entry me : cueList.cueMap.entrySet()) {
      Object keyName = me.getKey();
      Integer tempCue = (int)keyName;
      playList.add(tempCue);
    }
    for (Integer i : playList) {
      if (i > playListMax) {
        playListMax = i;
      }
    }
    println("play list, newPlaylist3 ", playList);
  }
}

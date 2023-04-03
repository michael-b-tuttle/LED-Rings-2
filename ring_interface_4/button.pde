void buttonsSetup() {
  int spacing = 25;
  clear = new ClearButton("Clear", secsInput.x, secsInput.y + 40, 50, 25);
  buttons.add(clear);
  countdown = new Countdown(secsInput.x +secsInput.xSize + 15, secsInput.y, secsInput.xSize, secsInput.ySize);
  send = new SendButton("Send", countdown.x, clear.y, 50, 25);
  buttons.add(send);
  gyroSwitch = new GyroSwitch("Color", wwFader.x, displayColor.y, 50, 25);
  buttons.add(gyroSwitch);
  reconfig = new Reconfig("Reset", pitchList.x + pitch.diameter / 2 - 10, pitch.y + pitch.diameter / 2 + 5, 50, 25);
  buttons.add(reconfig);
  add = new AddButton("Add/Update", redFader.x, height - 80, 85, 25);
  buttons.add(add);
  next = new NextButton("Next", add.x + add.xSize + spacing, add.y, 50, 25);
  buttons.add(next);
  prev = new PrevButton("Prev", next.x + next.xSize + spacing, add.y, 50, 25);
  buttons.add(prev);
  save = new SaveButton("Save", add.x + add.xSize + spacing, add.y + add.ySize + spacing, 50, 25);
  buttons.add(save);
  load = new LoadButton("Load", save.x + save.xSize + spacing, save.y, 50, 25);
  buttons.add(load);
  delete = new DeleteButton("Delete", prev.x + prev.xSize + spacing, add.y, 50, 25);
  buttons.add(delete);
  play = new PlayButton("Playing", secsInput.x, add.y, 50, 25);
  buttons.add(play);
}

//generic button class
class Button {
  float x, y, xSize, ySize;
  color pressed = color(150);
  color notPressed = color(200);
  color backColor = notPressed;
  boolean actionCalled = false;
  String name;
  Button(String _name, float _x, float _y, float _xSize, float _ySize) {
    name = _name;
    x = _x;
    y = _y;
    xSize = _xSize;
    ySize = _ySize;
  }
  void update() {
    if (mousePressed) {
      if (mouseX > x && mouseX < x + xSize
        && mouseY > y && mouseY< y + ySize) {
        action();
        actionCalled = true;
        backColor = pressed;
      }
    }
  }
  void action() {
  }
  void mouseUp() {
    actionCalled = false;
    backColor = notPressed;
  }
  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    fill(0);
    textSize(15);
    textAlign(LEFT, TOP);
    text(name, x + 3, y + 3);
  }
}

//to delete the seconds held in SecsBox and reset countdown timer to 0
class ClearButton extends Button {
  ClearButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      secsInput.value = "";
      countdown.countdownSecs = 0;
    }
  }
}

//send current color, timing, and gyro data to ring
//use enter key to trigger?
class SendButton extends Button {
  SendButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      countdown.update(int(secsInput.value));
      message.sendMessage();
    }
  }
}

//toggle the use of gyroscope on and off, to switch between a single color value or use gyro to map angle to color
class GyroSwitch extends Button {
  int state = 0;
  GyroSwitch(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      if (state == 0) {
        state = 1;
        name = "Range";
      } else if (state == 1) {
        state = 0;
        name = "Color";
      }
      backColor = (state==1) ? notPressed : pressed;
      for (ColorBox c : colorBoxes) {
        c.range = !c.range;
      }
      for (Fader f : faders) {
        f.update();
      }
    }
    inputsGetVals();
  }
}

//reset gyro, current position is new 0
//this is not working yet
class Reconfig extends Button {
  boolean reset = false;
  Reconfig(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      reset = true;
    }
  }
}

//add a cue to playlist, saves data to xml file
class AddButton extends Button {

  AddButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      cueList.addCue();
    }
    actionCalled = true;
  }
  void helpText() {
    text("press 'a', down arrow, up arrow", x, y- ySize);
  }
}

//++ current cue index
class NextButton extends Button {
  NextButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      cueIndex.indexUpdate(1);
      cueList.update();
    }
    actionCalled = true;
  }
}

//-- current cue index
class PrevButton extends Button {
  PrevButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      cueIndex.indexUpdate(-1);
      cueList.update();
    }
    actionCalled = true;
  }
}

//save, export playlist as xml file
class SaveButton extends Button {
  SaveButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      selectOutput("Select a file to write to:", "saveSelected");
    }
    actionCalled = true;
  }
}

void saveSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    saveXML(cueList.currList, selection.getAbsolutePath()+".xml");
    println(cueList);
  }
}

//load a playlist xml file
class LoadButton extends Button {
  LoadButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }

  void action() {
    if (!actionCalled) {
      selectInput("Select a file to process:", "loadSelected");
      cueIndex.value = "0";
      cueIndex.indexUpdate(0);
    }
    actionCalled = true;
  }
}

void loadSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    cueList.loadList(selection.getAbsolutePath());
    cueList.update();
  }
}
//delete current cue from playlist
class DeleteButton extends Button {
  DeleteButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }

  void action() {
    if (!actionCalled) {
      cueList.deleteCue();
    }
    actionCalled = true;
  }
}

//use spacebar to trigger?
class PlayButton extends Button {
  PlayButton(String _name, float _x, float _y, float _xSize, float _ySize) {
    super(_name, _x, _y, _xSize, _ySize);
  }
  void action() {
    if (!actionCalled) {
      player.action();
    }
  }
  void display() {
    fill(backColor);
    strokeWeight(3);
    stroke(150);
    rect(x, y, xSize, ySize);
    fill(0);
    textSize(15);
    textAlign(LEFT, TOP);
    if (player.isPlaying == true) {
      text(name, x + 3, y + 3);
    }
    else {
      text("Paused", x + 3, y + 3);
    }
  }
}

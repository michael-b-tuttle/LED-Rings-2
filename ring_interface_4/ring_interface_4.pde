import hypermedia.net.*;
import java.util.Map;

UDP udp;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress listenLocation, sendLocation;
ClearButton clear;
SendButton send;
Reconfig reconfig;
NextButton next;
PrevButton prev;
SaveButton save;
GyroSwitch gyroSwitch;
AddButton add;
LoadButton load;
DeleteButton delete;
PlayButton play;
Player player;
Countdown countdown;
ArrayList<Button> buttons = new ArrayList();
DisplayColor displayColor;
Fader redFader, greenFader, blueFader, wwFader, cwFader;
ArrayList<Fader> faders = new ArrayList();
SecsBox secsInput;
CueIndex cueIndex;
ColorBox rInput, rInputMin, gInput, gInputMin, bInput, bInputMin, wwInput, wwInputMin, cwInput, cwInputMin;
ArrayList<ColorBox> colorBoxes = new ArrayList();
List rollList, pitchList, yawList;
ArrayList<List> lists = new ArrayList();
Rotator roll, pitch, yaw;
ArrayList<Rotator> rotators = new ArrayList();
Message message;
CueList cueList;

void setup() {
  size(600, 600);
  surface.setLocation(0, 0);
  udp = new UDP( this, 12000 );
  udp.log( true );
  udp.listen( true );
  displayColor =new DisplayColor(50, 265, 130, 130);
  listsSetup();
  rotatorsSetup();
  faderSetup();
  inputsSetup();
  buttonsSetup();

  message = new Message();
  cueList = new CueList();
  cueList.update();
  player = new Player();
}

void draw() {
  background(180);
  for (Fader f : faders) {
    f.display();
  }
  displayColor.display();
  displayColor.colorRect();
  for (List c : lists) {
    c.update();
    c.display();
  }
  roll.update(mouseX);
  pitch.update(mouseY);
  for (Rotator r : rotators) {
    r.display();
  }
  secsInput.update();
  secsInput.display();
  for (ColorBox i : colorBoxes) {
    i.update();
    i.display();
  }

  for (Button b : buttons) {
    b.update();
    b.display();
  }
  add.helpText();
  countdown.calculate();
  countdown.display();

  cueIndex.update();
  cueIndex.display();
}

void keyPressed() {
  secsInput.input();
  cueIndex.input();
  for (ColorBox i : colorBoxes) {
    i.input();
  }
  if (keyCode == 40) {
    next.action();
    next.backColor = next.pressed;
    next.actionCalled = false;
  }
  if (keyCode == 38) {
    prev.action();
    prev.actionCalled = false;
  }
  if (keyCode == 65) {
    add.action();
    add.actionCalled = false;
  } 
}

void keyReleased() {
  if (keyCode == 40) {
    next.backColor = next.notPressed;
  }
  if (keyCode == 38) {
    prev.backColor = prev.notPressed;
  }
  if (keyCode == 65) {
    add.backColor = add.notPressed;
  }
  if (keyCode == 32) {
  }
}

void mousePressed() {
  for (Fader f : faders) {
    f.update();
  }
  displayColor.update();
}

void mouseReleased() {
  for (Button b : buttons) b.mouseUp();
}

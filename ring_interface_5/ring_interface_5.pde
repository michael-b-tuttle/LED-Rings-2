import hypermedia.net.*;
import java.util.Map;
import java.util.Locale;
import java.text.NumberFormat;

UDP udp;
import netP5.*;
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
//List rollList, pitchList, yawList;
//ArrayList<List> lists = new ArrayList();
//Rotator roll, pitch, yaw;
Rotator roll, pitch;
ArrayList<Rotator> rotators = new ArrayList();
Message message;
CueList cueList;
InputMess inputMess;

Locale english = new Locale("en");
NumberFormat englishNF = NumberFormat.getInstance(english);

void setup() {
  size(600, 600);
  surface.setLocation(0, 0);
  //String HOST_IP = "192.168.1.101";
  udp = new UDP( this, 12000);
  udp.log( true );
  udp.listen( true );
  println("me ", udp.port(), ", ", udp.address());

  displayColor =new DisplayColor(50, 265, 130, 130);
  //listsSetup();
  rotatorsSetup();
  faderSetup();
  inputsSetup();
  buttonsSetup();

  message = new Message();
  inputMess = new InputMess();
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
  //for (List c : lists) {
  //  c.update();
  //  c.display();
  //}
  //roll.update(mouseX);
  //pitch.update(mouseY);
  //inputMess.receive();
  roll.update(inputMess.yVal, (-1)*inputMess.pVal);
  pitch.update(inputMess.yVal, (-1)*inputMess.rVal);

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
  //println(keyCode);
  secsInput.input();
  cueIndex.input();
  for (ColorBox i : colorBoxes) {
    i.input();
  }
  if (keyCode == 39) {
    next.action();
    next.backColor = next.pressed;
    next.actionCalled = false;
  }
  if (keyCode == 37) {
    prev.action();
    prev.actionCalled = false;
  }
  if (keyCode == 65) {
    add.action();
    add.actionCalled = false;
  }
  if (keyCode == 10) {
    send.action();
    send.actionCalled = false;
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

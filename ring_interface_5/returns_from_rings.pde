//once a second receive data from ring
//this will be used to display the motions of the ring
class InputMess {
  Float rVal, pVal, yVal;
  InputMess() {
    //not really roll, pitch, and yaw. Instead more like: a, b, and c.
    rVal = 0.;
    pVal = 0.;
    yVal = 0.;
  }
}
void receive( byte[] data, String ip, int port ) {
  String message = new String(data);
  println("return tab, receive: \""+message+"\" from "+ip+" on port "+port);

  if (!message.isEmpty()) {
    String[] spStr = message.split(", ");
    println("spStr ", spStr.length);
    if (spStr.length > 1) {

      //println("0 ", spStr[0]);
      String[] roll = spStr[0].split("r");
      //println("roll str ", roll.length);
      inputMess.rVal = getVal(roll);
      //println("rVal ",inputMess.rVal);

      String[] pitch = spStr[1].split("p");
      inputMess.pVal = getVal(pitch);
      //println(pVal);
      //println("roll ",inputMess.rVal, ", pitch ", inputMess.pVal);
      String[] yaw = spStr[2].split("y");
      inputMess.yVal = getVal(yaw);
      println("roll ", inputMess.rVal, ", pitch ", inputMess.pVal, ", yaw ", inputMess.yVal);
    }
  }
}

Float getVal(String[] s) {
  Float num = 0.;
  String val = s[1];
  if (!Float.isNaN(Float.valueOf(val))) {
    num = Float.valueOf(val);
  }
  return num;
}

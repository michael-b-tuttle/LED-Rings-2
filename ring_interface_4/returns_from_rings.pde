//once a second receive data from ring
//this will be used to display the motions of the ring 
void receive( byte[] data, String ip, int port ) {
  String message = new String(data);
  println("return tab, receive: \""+message+"\" from "+ip+" on port "+port);
  if (!message.isEmpty()) {
    String[] spStr = message.split(", ");
    String[] roll = spStr[0].split("r");
    println("roll ", roll);
    Float rVal = getVal(roll);
    println(rVal);
    String[] pitch = spStr[1].split("p");
    Float pVal = getVal(pitch);
    println(pVal);
    String[] yaw = spStr[2].split("y");
    Float yVal = getVal(yaw);
    println("roll ", rVal, ", pitch ", pVal, ", yaw ", yVal);
  }
}

Float getVal(String[] s) {
  String val = s[1];
  Float num = 0.;
  if (!Float.isNaN(Float.valueOf(val))) {
    num = Float.valueOf(val);
  }
  return num;
}

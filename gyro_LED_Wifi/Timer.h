//Calculates the time from now to next color state
#ifndef TIMER_H
#define TIMER_H

class Timer {
  public:
    float amount = 0;
    float startTime;
    float countdownLength;
    bool counting = false;
    void start(float _countdownLength) {
      countdownLength = _countdownLength;
      startTime = millis();
      counting = true;
      amount = 0;
    }
    void calculate() {
      if (counting) {
        amount = (millis()-startTime) / countdownLength;
//        Serial.print("amount ");
//        Serial.println(amount);
      }
      if (amount > 1) {
        amount = 1;
        counting = false;
//        Serial.print("counting ");
//        Serial.println(counting);
      }
    }
};
#endif

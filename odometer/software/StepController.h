

class StepController {
  
 private:
  volatile unsigned long quad_pulse_num;
  volatile unsigned long target_pulse_num;

  byte motor_speed;
  int motor_pin;
  
 public:
  
  void begin(int motorPin, byte speed) {
    motor_pin = motorPin;
    motor_speed = speed;
    digitalWrite(motor_pin, LOW);
    pinMode(motor_pin, OUTPUT);

    quad_pulse_num = 0;
    target_pulse_num = 0;
  }
  
  void quadPulse() {
    quad_pulse_num++;
    
    if (target_pulse_num <= quad_pulse_num) {
      analogWrite(motor_pin, 0);
      quad_pulse_num = 0;
      target_pulse_num = 0;
    }
  }
  
  void advance(unsigned long numSteps) {
//    noInterrupts();
    target_pulse_num += numSteps;
//    Serial.print("New target_pulse_num: ");
//    Serial.println(target_pulse_num);
//    Serial.print("Current pulse num: ");
//    Serial.println(quad_pulse_num);
//    interrupts();
    analogWrite(motor_pin, motor_speed);
  }
  
};

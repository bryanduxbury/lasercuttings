
class SpeedController {
private:
//  unsigned long last_transition_usec;
//  int current_state;
//  int current_interval;
   
  int drive_pin;
  int pulses_per_rotation;
  
  unsigned long pulse_width_usec;
  
  volatile double target_rpm;
  volatile double current_rpm;
  
  unsigned long last_quadrature_pulse_usec;
  
  void determineMinPulseLength() {
    // placeholder logic; we should determine this by doing some sort of binary search and counting pulses.
    pulse_width_usec = 10000;
  }
  
public:
  
  void begin(int drivePin, int pulsesPerRotation) {
    drive_pin = drivePin;
    pulses_per_rotation = pulsesPerRotation;
    
    
    digitalWrite(drive_pin, LOW);
    pinMode(drive_pin, OUTPUT);
    
    determineMinPulseLength();
  }
  
  void loop() {
    
  }
  
  void quadraturePulse() {
    unsigned long curPulseMicros = micros();
  
    unsigned long timeSinceLastPulseMicros = curPulseMicros - last_quadrature_pulse_usec;
    unsigned long usecPerRevolution = pulses_per_rotation * timeSinceLastPulseMicros;
    double minutesPerRevolution = usecPerRevolution / 1000.0 / 1000.0 / 60.0;
    current_rpm = 1.0 / minutesPerRevolution;
    last_quadrature_pulse_usec = curPulseMicros;
  }
  
  void setTargetRPM(double r) {
    target_rpm = r;
  }
  
  double getTargetRPM() {
    return target_rpm;
  }
  
  double getCurrentRPM() {
    return current_rpm;
  }
};

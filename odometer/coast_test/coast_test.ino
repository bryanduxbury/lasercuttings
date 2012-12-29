

volatile unsigned long quad_pulse_count;
volatile unsigned long stoppedAt;

void setup() {
  Serial.begin(9600);
  
  pinMode(5, OUTPUT);
  analogWrite(5, 0);
  
  quad_pulse_count = 0;
  stoppedAt = 0;

  attachInterrupt(0, quadPulse, CHANGE);
  attachInterrupt(1, quadPulse, CHANGE);
  
//  analogWrite(5, 128);
  
//  while (stoppedAt == 0) {}
  
//  Serial.println("And we're done.");
//  Serial.print("Step count after stopping: ");
//  Serial.println(quad_pulse_count);
//  
////  delay(1000);
//  
//  Serial.print("Step count after waiting (coast amount): ");
//  Serial.println(quad_pulse_count);
}

volatile unsigned long target_pulse_num;

void quadPulse() {
  quad_pulse_count++;
  
  if (quad_pulse_count >= target_pulse_num) {
    analogWrite(5, 0);
//    stoppedAt = micros();
  }
}

void loop() {
  target_pulse_num += 5 * 1200 * 1.7;
  analogWrite(5, 96);
  delay(60000);
}

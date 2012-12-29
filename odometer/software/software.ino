// TODO: config params in eeprom
// TODO: config ui on web page
// TODO: display steps remaining to be taken on web ui
// TODO: consider taking small bursts to cope with coasting
// TODO: factory reset functionality

#include <SPI.h>
#include <Ethernet.h>
//#include "SpeedController.h"
#include "StepController.h"
#include "TimerOne.h"

#define PULSES_PER_DIGIT (5 * 1200 / 10)

#define MOTOR_PIN 5
#define BUTTON_PIN 7

//#define MAX_FAULT_PIN 7
//#define COMM_PIN 8

byte mac[] = { 0x00, 0xAA, 0xBB, 0xCC, 0xDA, 0x02 };
IPAddress ip(10,1,1,123);

EthernetServer server(80);

//SpeedController speed_controller;
StepController step_controller;

void setup() {
  Serial.begin(9600);
  Serial.println("Starting up ethernet stack");
  Ethernet.begin(mac, ip);
  Serial.println("Finished starting ethernet.");
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
  
  
  // attach interrupts to int 0 + int 1 for the quadrature pulses
  attachInterrupt(0, quadraturePulse, CHANGE);
  attachInterrupt(1, quadraturePulse, CHANGE);

  step_controller.begin(MOTOR_PIN, 128);
}

void quadraturePulse() {
  step_controller.quadPulse();
}

void processHttpRequests() {
  // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    boolean firstLine = true;
    char firstLineBuffer[255];
    firstLineBuffer[254] = '\0';
    char* firstLineBufferPointer = firstLineBuffer;

    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (firstLine) {
          *firstLineBufferPointer = c;
          firstLineBufferPointer++;
        }

        // check the request line for any setter params
        if (c == '\n' && firstLine) {
          *firstLineBufferPointer = '\0';
          firstLine = false;
          Serial.print("Captured first line: ");
          Serial.print(firstLineBuffer);

          for (firstLineBufferPointer = firstLineBuffer; *firstLineBufferPointer != '\0'; firstLineBufferPointer++) {
            if (*firstLineBufferPointer == '?') {
              Serial.println("Woot! It's a setter param!");
              // start parsing from here
              firstLineBufferPointer++;
              if (*firstLineBufferPointer == 'c') {
                Serial.println("Woah! Check it! We're supposed to set the target rpm!");
                Serial.print("Here's what the buffer looks where we're planning to start: ");
                Serial.println(firstLineBufferPointer+1);
                // setting target RPM
                // skip the 'r=' part
                firstLineBufferPointer+=2;
                Serial.println(atol(firstLineBufferPointer));
                step_controller.advance(atol(firstLineBufferPointer) * PULSES_PER_DIGIT);
              }
            }
          }
        }

        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println("Connnection: close");
          client.println();
          client.println("<!DOCTYPE HTML>");
          client.println("<html>");

          // add a meta refresh tag, so the browser pulls again every 5 seconds:
//          client.println("<meta http-equiv=\"refresh\" content=\"5\">");

          client.println("<form action='/'>");
//          client.println("Target RPM:");
          client.print("<input type=text name=c value='"); client.println("'/>");
          client.println("<input type=submit value='Advance Count'/>");
          client.println("</form>");

          client.println("</html>");
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } 
        else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disonnected");
  }
}

void loop() {
  processHttpRequests();
//  step_controller.advance(100);
  delay(10);
}

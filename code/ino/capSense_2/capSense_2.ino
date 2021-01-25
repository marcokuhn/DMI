#include <CapacitiveSensor.h>

/*
    DMI course, WS 2020-21 @ SRH
    hannes@earweego.net
    this is based on the example sketch listed below.
    amended by Array synbtax for easier extension

    send Capacitive Sensing pins on Serial

    wiring: all send pins are 12,
    receive pins are {14, 15, 16, 17, 18, 19, 20, 21, 22}

   !! You must select MIDI from the "Tools > USB Type" menu
   http://www.pjrc.com/teensy/td_midi.html

   This example code is in the public domain.

   CapitiveSense Library Demo Sketch
   Paul Badger 2008
   Uses a high value resistor e.g. 10M between send pin and receive pin
   Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
   Receive pin is the sensor pin - try different amounts of foil/metal on this pin

*/
int thresh = 20;

const byte numTouches = 3;
//const byte touchPins[] = {3, 4, 15, 16, 17, 18, 19, 22, 23 }; // on Teensy LC, simply use touchRead(pin)
//const byte touchPins[] = {14, 15, 16, 17, 18, 19, 20, 21, 22 }; // on Teensy 4
const byte touchPins[] = { 2, 6, 8}; // as in Example
// array of objects: https://arduino.stackexchange.com/questions/53161/how-can-i-initialize-an-array-of-objects-in-setup
CapacitiveSensor *touchSensors[numTouches];

void setup()
{
  for (byte i = 0; i <= numTouches; i++) {
    touchSensors[i] = new CapacitiveSensor(4, touchPins[i] );
    touchSensors[i]->set_CS_Timeout_Millis(500); // tweak
  }

  Serial.begin(9600);
  Serial.println("Teensy cap sensing \n\n");                  // print sensor output 1
  Serial.println("Teensy cap sensing \n\n");                  // print sensor output 1
  Serial.println("Teensy cap sensing \n\n");                  // print sensor output 1
  Serial.println("Teensy cap sensing \n\n");                  // print sensor output 1
}

void loop()
{
  long start = millis();
  for (byte i = 0; i <= numTouches; i++) {
    long total =  touchSensors[i]->capacitiveSensor(10);
//    if (total < thresh && total > 0) {
//      Serial.print("*trig*");                // print sensor output 1
//    } else {
      Serial.print(total);
//    }
    Serial.print("\t");
  }
  Serial.print(millis() - start);        // check on performance in milliseconds
  Serial.println("");

  delay(10);                             // arbitrary delay to limit data to serial port
}

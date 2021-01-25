#include <CapacitiveSensor.h>

/*
   CapitiveSense Library Demo Sketch
   Paul Badger 2008
   Uses a high value resistor e.g. 10M between send pin and receive pin
   Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
   Receive pin is the sensor pin - try different amounts of foil/metal on this pin

  capsense pins:
  0,1,
  3,4,
  15, 16, 17, 18, 19,
  22,23
*/
const byte numTouches = 4;
const byte touchPins[] = {3, 4, 15, 16, 17, 18, 19, 22, 23 }; // on Teensy LC

// array of objects: https://arduino.stackexchange.com/questions/53161/how-can-i-initialize-an-array-of-objects-in-setup
CapacitiveSensor *touchSensors[numTouches];
//  CapacitiveSensor   cs_4_15 = CapacitiveSensor(4, 15);       // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
//  CapacitiveSensor   cs_4_16 = CapacitiveSensor(4, 16);       // 10M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
//  CapacitiveSensor   cs_4_17 = CapacitiveSensor(4, 17);
//  CapacitiveSensor   cs_4_18 = CapacitiveSensor(4, 18);



void setup()
{
  for (byte i = 0; i <= numTouches; i++) {
    touchSensors[i] = new CapacitiveSensor(4, 15 + i);
    //    touchSensors[i] = new CapacitiveSensor(4, touchPins[i]);
    touchSensors[i]->set_CS_Timeout_Millis(500);
  }

  Serial.begin(9600);
  Serial.println("Teensy cap sensing \n\n");                  // print sensor output 1
  //    cs_4_15.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  //    cs_4_15.set_CS_Timeout_Millis(500);
  //    cs_4_16.set_CS_Timeout_Millis(500);
  //    cs_4_17.set_CS_Timeout_Millis(500);
  //    cs_4_18.set_CS_Timeout_Millis(500);
}

void loop()
{
  long start = millis();

  //  long total1 =  cs_4_15.capacitiveSensor(3);
  //  long total2 =  cs_4_16.capacitiveSensor(3);
  //  long total3 =  cs_4_17.capacitiveSensor(3);
  //  long total4 =  cs_4_18.capacitiveSensor(3);

  for (byte i = 0; i <= numTouches; i++) {
    long total =  touchSensors[i]->capacitiveSensor(3);
    Serial.print(total);                  // print sensor output 1
    Serial.print("\t");
  }

  //  Serial.print("\t");                    // tab character for debug windown spacing
  //  Serial.print(total2);                  // print sensor output 2
  //  Serial.print("\t");
  //  Serial.print(total3);                  // print sensor output 3
  //  Serial.print("\t");
  Serial.print("\t");
  Serial.print(millis() - start);        // check on performance in milliseconds
  Serial.println("");                // print sensor output 3

  delay(10);                             // arbitrary delay to limit data to serial port
}

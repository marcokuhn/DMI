#include <CapacitiveSensor.h>

/*
   CapitiveSense Library Demo Sketch
   Paul Badger 2008
   Uses a high value resistor e.g. 10M between send pin and receive pin
   Resistor effects sensitivity, experiment with values, 50K - 50M. Larger resistor values yield larger sensor values.
   Receive pin is the sensor pin - try different amounts of foil/metal on this pin
*/

const int maxTime = 3;
const int timeOut_ms = 10;

CapacitiveSensor   cs_4_14 = CapacitiveSensor(4, 14);       // 10M resistor between pins 4 & 2, pin 2 is sensor pin, add a wire and or foil if desired
CapacitiveSensor   cs_4_15 = CapacitiveSensor(4, 15);       // 10M resistor between pins 4 & 6, pin 6 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_4_16 = CapacitiveSensor(4, 16);       // 10M resistor between pins 4 & 8, pin 8 is sensor pin, add a wire and or foil
CapacitiveSensor   cs_4_17 = CapacitiveSensor(4, 17);       // 10M resistor between pins 4 & 8, pin 10 is sensor pin, add a wire and or foil

void setup()
{
  //   cs_4_14.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  cs_4_14.set_CS_Timeout_Millis(timeOut_ms);
  cs_4_15.set_CS_Timeout_Millis(timeOut_ms);
  cs_4_16.set_CS_Timeout_Millis(timeOut_ms);
  cs_4_17.set_CS_Timeout_Millis(timeOut_ms);

  Serial.begin(9600);
}

void loop()
{
  long start = millis();
  long total1 =  cs_4_14.capacitiveSensor(maxTime);
  long total2 =  cs_4_15.capacitiveSensor(maxTime);
  long total3 =  cs_4_16.capacitiveSensor(maxTime);
  long total4 =  cs_4_17.capacitiveSensor(maxTime);

  Serial.print(millis() - start);        // check on performance in milliseconds
  Serial.print("\t");                    // tab character for debug windown spacing

  Serial.print(total1);                  // print sensor output 1
  Serial.print("\t");
  Serial.print(total2);                  // print sensor output 2
  Serial.print("\t");
  Serial.print(total3);                // print sensor output 3
  Serial.print("\t");
  Serial.print(total4);                // print sensor output 3
  Serial.println("");
  delay(10);                             // arbitrary delay to limit data to serial port
}

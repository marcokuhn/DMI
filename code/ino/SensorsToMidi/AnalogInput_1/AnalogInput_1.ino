/* DMI coursew, WS 2020-21 @ SRH
 *  hannes@earweego.net
 *  this is based on the plain Analog Read Example from the Teensy library.
 *  
 *  Wiring: connect a wire each to A0 (14), GND (25) and 3,3V (24).
 *  run sketch and touch the "hot" wire A0 alternately with GND or V+, 
 *  and "measure the resistance" by touching it with your hand
 *   
 *   play clicks on the Piezo - connect it to GND an Pin 0
*/

const int framesPerSec = 4400;

void setup()
{                
  Serial.begin(38400); // fast Serial port
}

int analogVal;
int roundedVal;
boolean boolVal;

void loop()                     
{
  analogVal = analogRead(0);  // read 1 value
  

  roundedVal = analogVal >> 5;
  boolVal = roundedVal % 2;
  digitalWrite(0, boolVal);  // write a pulse wave to the piezo on pin 0
    
//  Serial.print("analog 0 is: ");  // print it on the Serial console
  Serial.println(roundedVal);
  
  delay(1000/framesPerSec);
}

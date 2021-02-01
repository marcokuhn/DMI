/* DMI coursew, WS 2020-21 @ SRH
 *  hannes@earweego.net
 *  this is based on the plain Analog Read Example from the Teensy library.
 *  
 *  Wiring: connect a wire each to A0 (14), GND (25) and 3,3V (24).
 *  run sketch and touch the "hot" wire A0 alternately with GND or V+, 
 *  and "measure the resistance" by touching it with your hand
 *  
 *  Analog Input Example, Teensyduino Tutorial #4
   http://www.pjrc.com/teensy/tutorial4.html

   After uploading this to your board, use Serial Monitor
   to view the message.  When Serial is selected from the
   Tools > USB Type menu, the correct serial port must be
   selected from the Tools > Serial Port AFTER Teensy is
   running this code.  Teensy only becomes a serial device
   while this code is running!  For non-Serial types,
   the Serial port is emulated, so no port needs to be
   selected.

   This example code is in the public domain.
*/

const int framesPerSec = 50;

void setup()
{                
  Serial.begin(38400); // fast Serial port
}

int analogVal;

void loop()                     
{
  analogVal = analogRead(0);  // read 1 value
  
  Serial.print("analog 0 is: ");  // print it on the Serial console
  Serial.println(analogVal);
  
  delay(1000/framesPerSec);
}

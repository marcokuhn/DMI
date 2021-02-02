/* DMI course, WS 2020-21 @ SRH
    hannes@earweego.net
    this is based on the "USB MIDI AnalogControlChange" Example frm teh Teensy library
    written in Array synbtax for easier extension

    Wiring: 4 times the wiring of the single channel example AnalogControlChange_0
    Connect a wire each to A0 (14), A1, A2, A3 = 15, 16, 17,
    GND (25) and 3,3V (24).
    a high Ohm resistor (~1MOhm) between Ax and GND
    "measure resistance" by touching your hand between the hot pin and V+.

    send analog reading out as MIDI

   !! You must select MIDI from the "Tools > USB Type" menu
   http://www.pjrc.com/teensy/td_midi.html

   This example code is in the public domain.
*/

// the MIDI channel number to send messages
const int channel = 1;
const int framesPerSec = 50; // rate of measurements - 50 per sec is usually sufficient.

const byte numReads = 4;
const int analogPins[] = { A0, A1, A2, A3 };
const int ccs[] = { 0, 1, 2, 3 }; // send these CC nums
int prevVals[] = {}; // cache previous readings

void setup() {
  Serial.begin(38400); // fast Serial port

  for (byte i = 0; i <= numReads; i++) {
    prevVals[i] = 0;
  }
}

elapsedMillis msec = 0;

void loop() {
  // only check the analog inputs at 'framesPerSec' rate
  // to prevent a flood of MIDI messages
  if (msec >= 1000/framesPerSec) {
    msec = 0;

    Serial.print("MIDI vals: ");  // print it on the Serial console

    for (byte i = 0; i <= numReads; i++) {
      int readVal = analogRead(analogPins[i]) >> 3; // reduce 10 bit to 7 bit
      // only transmit MIDI messages if analog input changed
      if (readVal != prevVals[i]) {
        usbMIDI.sendControlChange(ccs[i], readVal, channel);
        
        Serial.print("\tCC " );
        Serial.print( ccs[i]);
        Serial.print( ": " );
        Serial.print( readVal );
        
        prevVals[i] = readVal;
      }
    }
    Serial.println("");
  }

  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
    // ignore incoming messages
  }
}

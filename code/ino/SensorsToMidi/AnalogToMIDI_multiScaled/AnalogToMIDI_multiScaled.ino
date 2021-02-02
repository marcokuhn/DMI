/* DMI course, WS 2020-21 @ SRH
    hannes@earweego.net
    this is based on the "USB MIDI AnalogControlChange" Example frm teh Teensy library
    written in Array synbtax for easier extension

    Wiring: 4 times the wiring of the single channel example AnalogControlChange_0
    Connect a wire each to A0 (14), A1, A2, A3 = 15, 16, 17,
    GND (25) and 3,3V (24).
    a high Ohm resistor (~1MOhm) between Ax and GND
    "measure resistance" by touching your hand on both the "hot" pin and V+. Or connect V+ to a wristband...

    - scale to make low range more sensitive BEFORE sending out MIDI!

    send analog readings out as MIDI

   !! You must select MIDI from the "Tools > USB Type" menu
   http://www.pjrc.com/teensy/td_midi.html

   This example code is in the public domain.
*/

// tweak vars
const int channel = 1;
const int framesPerSec = 50; // rate of measurements - 50 per sec is usually sufficient.
boolean doSerial = true;

// internal vars
const byte numReads = 4;
const int analogPins[] = { A0, A1, A2, A3 };
const int ccs[] = { 0, 1, 2, 3 }; // send these CC nums
int prevVals[numReads] = {}; // cache previous readings

void setup() {
  Serial.begin(38400); // fast Serial port

  for (byte i = 0; i <= numReads; i++) {
    prevVals[i] = -1;  // fill prevVals
  }
}

elapsedMillis msec = 0;

void loop() {
  // only check the analog inputs at 'framesPerSec' rate
  // to prevent a flood of MIDI messages
  if (msec >= 1000 / framesPerSec) {
    msec = 0;

    Serial.print("MIDI vals: ");  // print it on the Serial console

    for (byte i = 0; i <= numReads; i++) {
      int readVal = analogRead(analogPins[i]);  // keep it full res
      float curve = pow((readVal / 128.), 0.5); // square root curve for better res. in low range.
      int sendVal = constrain(int(curve * 128.0), 0, 127);         // back to int, make sure it doies not exceed legal MIDI ranges

      // only transmit MIDI messages if analog input changed
      if (sendVal != prevVals[i]) {
        usbMIDI.sendControlChange(ccs[i], sendVal, channel);

        if (doSerial) { // serial may be switched off.
          Serial.print("\tCC " );
          Serial.print( ccs[i]);
          Serial.print( ": " );
          Serial.print( readVal );
        }
        prevVals[i] = sendVal;
      }
    }
    if (doSerial) {
      Serial.println("");
    }
  }

  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
    // ignore incoming messages
  }
}

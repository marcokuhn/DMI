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
const int framesPerSec = 66; // rate of measurements - 50 per sec is usually sufficient.
boolean doSerial = false;

// internal vars
const byte numReads = 4;
const int analogPins[] = { A0, A1, A2, A3 };
const int ccs[] = { 0, 1, 2, 3 }; // send these CC nums
int prevVals[numReads] = {}; // cache previous readings
float minima[numReads] = {}; // min vals
float maxima[numReads] = {}; // max vals
int dt = 1000 / framesPerSec;
int readInt;
float readVal;

void setup() {
  Serial.begin(38400); // fast Serial port
  Serial.print("HELLO WORLD: \n\n 4 analogs to midi, autocalibrating \n\n\n Serial posting is ");
  Serial.println(doSerial);


  for (byte i = 0; i < numReads; i++) {
    prevVals[i] = -1;  // fill prevVals
    minima[i] = 1.;
    maxima[i] = 0.;
  }
}

elapsedMillis msec = 0;

void loop() {
  // only check the analog inputs at 'framesPerSec' rate
  // to prevent a flood of MIDI messages

  if (msec >= dt) {
    msec = 0;

    //    digitalWrite(13, random(10) < 2);

    if (doSerial) { // serial may be switched off.
      Serial.println("MIDI vals: ");  // print it on the Serial console
    }

    for (byte i = 0; i < numReads; i++) {
       readInt = analogRead(analogPins[i]);  // keep it full res, range 0 to 1.
       readVal = readInt / 1024.;
      // autocal:
      if (readVal < minima[i]) {
        minima[i] = readVal;
      }
      if (readVal > maxima[i]) {
        maxima[i] = readVal;
      }
      // remap the readVal
      float calVal = map(readVal, minima[i], maxima[i], 0.0, 1.0);

      // square root curve for better res. in low range.
      float curve = pow((calVal), 0.5);
      // back to int, make sure it does not exceed legal MIDI ranges
      int sendVal = constrain(int(curve * 128.0), 0, 127);
      // only transmit MIDI messages if sendVal really changed.
      if (sendVal != prevVals[i]) {
        usbMIDI.sendControlChange(ccs[i], sendVal, channel);
        prevVals[i] = sendVal;
      }

      if (doSerial) {
        // debug only
        Serial.print("CC " );
        Serial.print( ccs[i]);
        Serial.print("\treadInt " );
        Serial.print( readInt );
        Serial.print("\tmin " );
        Serial.print( minima[i]);
        Serial.print("\tmax " );
        Serial.print( maxima[i]);
        Serial.print( "\tsend: " );
        Serial.print( sendVal );

        Serial.println("");
      }
    }
  }

  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
    // ignore incoming messages
  }
}

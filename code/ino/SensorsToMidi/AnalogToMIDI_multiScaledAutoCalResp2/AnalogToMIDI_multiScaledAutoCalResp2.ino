/*
    DMI course, WS 2020-21 @ SRH
    hannes@earweego.net

    this is based on examples frm the Teensy library
    written in Array syntax for easier multi-channel extension

  // =========================================================
    Wiring:
    4 channels (A0 .. A3) = Pin (14..17)
    connect a high Ohm (~1MOhm) resistor between Ax and +3.3V (Pullup)
    "measure resistance" by touching your hands on both the "hot" pin and GND.
    Or connect GND to a wristband, touch the heating tube, or mains GND,... for a permanent grounding of your body...

          _____________________
          |       |   |   |   |
          |      R0  R1  R2  R3   < pullup line - all tied to V3.3 via 1MOhm Resistors
          |       |   |   |   |
    GND  3.3V+   A0  A1  A2  A3   < Teensy Pins
      |           |   |   |   |
      |           |   |   |   |
      O           O   O   O   O   < Touch points
  // =========================================================

    - scaling to make low range more sensitive BEFORE sending out MIDI!
    - send readings out as MIDI CC
    !! You must select MIDI from the "Tools > USB Type" menu
    http://www.pjrc.com/teensy/td_midi.html

   This example code is in the public domain.
*/
#include <ResponsiveAnalogRead.h>  // lib from  https://github.com/dxinteractive/ResponsiveAnalogRead

// tweak vars
const int midiChannel = 1;
const int framesPerSec = 66; // rate of measurements - 50 per sec is usually sufficient.
boolean doSerial = true;
const byte numReads = 4;
const int analogPins[] = { A0, A1, A2, A3 };
const int ccs[] = { 0, 1, 2, 3 }; // send these CC nums

// internal vars
float minima[numReads] = {}; // min vals
float maxima[numReads] = {}; // max vals
int dt = 1000 / framesPerSec;
int readInt;
float readFloat;
const float initialMin = 0.5;
const float initialMax = 0.;
boolean doSendMidi = false;

//ResponsiveAnalogRead analog(ANALOG_PIN, true);
ResponsiveAnalogRead *touchSensors[numReads];


void setup() {
  Serial.begin(38400); // fast Serial port
  Serial.print("HELLO WORLD: \n\n 4 analogs to midi, autocalibrating \n\n\n Serial posting is ");
  Serial.println(doSerial);

  for (byte i = 0; i < numReads; i++) {
    touchSensors[i] = new ResponsiveAnalogRead(analogPins[i], true); // pin, enableSleep
    minima[i] = initialMin; // init autocal's min and max
    maxima[i] = initialMax;
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
      //       readInt = analogRead(analogPins[i]);  // keep it full res, range 0 to 1.
      touchSensors[i]->update();
      readInt = touchSensors[i]->getValue();
   //   readInt = 1024 - readInt; // invert reading, since, with pullup, no touch corresponds to max reading; and we want it to be close to 0.

      readFloat = readInt / 1024.;
      // autocal:
      if (readFloat < minima[i]) {
        minima[i] = readFloat;
      }
      if (readFloat > maxima[i]) {
        maxima[i] = readFloat;
      }
      // remap the readFloat
      float calVal = map(readFloat, minima[i], maxima[i], 0.0, 1.0);

      // curving via power function for better res. in low range.
      float curve = pow((calVal), 0.5); // ** 0.5 -> square root
      // back to int, make sure it does not exceed legal MIDI ranges
      int sendVal = constrain(int(curve * 128.0), 0, 127);
      // only transmit MIDI messages if sendVal really changed.
      if ( touchSensors[i]->hasChanged() && doSendMidi ) {  // suppress early sending, as it tends to send extremely fluctuating values
        usbMIDI.sendControlChange(ccs[i], sendVal, midiChannel);
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

  // check if electrodes have been touched == min and max vals have changed from init state, then allow sending midi
  if (!doSendMidi) {
    if (millis() < 3000) {
      float tempMin = 0., tempMax = 0.;
      for (byte i = 0; i < numReads; i++) {
        tempMin += minima[i];
        tempMax += maxima[i];
      }
      if ((tempMin != ( initialMin * 4.)) && (tempMax != (initialMax * 4.)) ) {
        doSendMidi = true;
      }
    }
  };

  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
    // ignore incoming messages
  }
}

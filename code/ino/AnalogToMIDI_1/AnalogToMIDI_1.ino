/* DMI coursew, WS 2020-21 @ SRH
    hannes@earweego.net
    this is based on the "USB MIDI AnalogControlChange" Example frm teh Teensy library

    Wiring:
    Connect a wire each to A0 (14), GND (25) and 3,3V (24).
    a high Ohm resistor (~1MOhm) between Ao and GND
    "measure resistance" by touching your hand between the hot pin and V+.

    send analog reading out as MIDI

   !! You must select MIDI from the "Tools > USB Type" menu
   http://www.pjrc.com/teensy/td_midi.html

   This example code is in the public domain.
*/

// the MIDI channel number to send messages
const int channel = 1;
const int framesPerSec = 50; // rate of measurements - 50 per sec is usually sufficient. 

// the MIDI continuous controller for each analog input
const int controllerA0 = 0;  // CC 0

void setup() {
}

// store previously sent values, to detect changes
int previousA0 = -1;
int delayms = 1000 / framesPerSec;
elapsedMillis msec = 0;

void loop() {
  // only check the analog inputs 50 times per second,
  // to prevent a flood of MIDI messages
  if (msec >= delayms) {
    msec = 0;
    int n0 = analogRead(A0) / 8;

    // only transmit MIDI messages if analog input changed
    if (n0 != previousA0) {
      usbMIDI.sendControlChange(controllerA0, n0, channel);
      previousA0 = n0;
    }
  }

  // MIDI Controllers should discard incoming MIDI messages.
  // http://forum.pjrc.com/threads/24179-Teensy-3-Ableton-Analog-CC-causes-midi-crash
  while (usbMIDI.read()) {
  }
}

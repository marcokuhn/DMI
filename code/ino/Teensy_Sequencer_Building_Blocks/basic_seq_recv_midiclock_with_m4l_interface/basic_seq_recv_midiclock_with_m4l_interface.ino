/* DMI coursew, WS 2020-21 @ SRH
   marco.kuhn@srh.de

  -> EXAMPLE HOW TO SYNC to external MIDI-CLOCK via USB.MIDI
  -> M4L Interface = teensy_seq_ctrl_interface_midi_clock.amxd
   
    based on the code from 2kohm:
    https://github.com/2kohm/Teensy-USB-MIDI-CLOCK/blob/master/Teensy_midi.ino
    
*/
// ************************* START – GENERATED BY AUDIO DESIGN TOOL 
#include <Audio.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>

// GUItool: begin automatically generated code
AudioSynthSimpleDrum     drum1;          //xy=892.2000122070312,364.2000045776367
AudioOutputI2S           i2s1;           //xy=1077.199951171875,364.2000045776367
AudioConnection          patchCord1(drum1, 0, i2s1, 0);
AudioConnection          patchCord2(drum1, 0, i2s1, 1);
AudioControlSGTL5000     sgtl5000_1;     //xy=904.199951171875,452.20003509521484
// GUItool: end automatically generated code
// ************************* END – GENERATED BY AUDIO DESIGN TOOL 


byte midi_clock_counter = 0;
byte midi_clockdivider = 6;

int kickSteps[16] = {1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0};

bool seqPlay = true;
int seqStep = 0;
int prevSeqStep = 15;


void setup() {
  AudioMemory(20);
  sgtl5000_1.enable();
  sgtl5000_1.volume(0.32);

  drum1.frequency(80);
  drum1.length(300);

  usbMIDI.setHandleControlChange(getControlChangeMsg);
  usbMIDI.setHandleRealTimeSystem(RealTimeSystem);
  Serial.begin(115200);
}

void loop() {
  // The handler functions are called when usbMIDI reads data.  They
  // will not be called automatically.  You must call usbMIDI.read()
  // regularly from loop() for usbMIDI to actually read incoming
  // data and run the handler functions as messages arrive.
  usbMIDI.read();

  //DRUMS
  if (seqPlay) {
    //setSeqStep();
    if (seqStep >= 16) {
      seqStep = 0;
    }

    //Play Pattern
    if (abs(seqStep - prevSeqStep) > 0) {

      if (kickSteps[seqStep]) {
        drum1.noteOn();
      }
    }
    prevSeqStep = seqStep;
  }
}

/*
  RealTimeSystem – process MIDI real time messages (MIDI system clock)
  Midiclock events are sent at a rate of 24 pulses per quarter note
*/
void RealTimeSystem(byte realtimebyte) {
  
  // 248 = CLOCK
  if (realtimebyte == 248)
  {
    midi_clock_counter++;

    if (midi_clock_counter == midi_clockdivider)
    {
      midi_clock_counter = 0;
      seqStep++;
      //send stepIndex to M4L
      usbMIDI.sendControlChange(30, seqStep, 1);
    }

  }
  // 250 = START and 251 = CONTINUE
  if (realtimebyte == 250 || realtimebyte == 251)
  {
    midi_clock_counter = 0;
  }

  // 252 = STOP
  if (realtimebyte == 252)
  {

  }

}

void getControlChangeMsg(byte channel, byte control, byte value) {
  
  // get Pattern from M4L via MIDI-CC
  if (control >= 50 && control <= 65) {
    int stepIndex = control - 50;
    kickSteps[stepIndex] = value;
  } else {

    switch (control) {
      // set clock divider for Real Time MIDI CLOCK
      case 70:
        midi_clockdivider = 24; // 1/4
        break;
      case 71:
        midi_clockdivider = 12; // 1/8
        break;
      case 72:
        midi_clockdivider = 6; // 1/16
        break;
      case 73:
        midi_clockdivider = 3; // 1/32
        break;
      case 74:
        midi_clockdivider = 2; // 1/64
        break;
    }
  }
}

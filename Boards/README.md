# Physical-Computing-Boards

> state: early 2021

- [Physical-Computing-Boards](#physical-computing-boards)
  - [Teensy](#teensy)
    - [Getting Started](#getting-started)
    - [Audio](#audio)
    - [WIFI Extension](#wifi-extension)
    - [Building a Synth with Teensy](#building-a-synth-with-teensy)
    - [Example Audio Projects](#example-audio-projects)
  - [DAISY Board](#daisy-board)
  - [AXOLOTI Board](#axoloti-board)
  - [BELA](#bela)
  - [Raspberry Pi](#raspberry-pi)
  - [ESP Series](#esp-series)
      - [Example Audio Projects](#example-audio-projects-1)
    - [ESP8266](#esp8266)
      - [ESP8266 ESP-01](#esp8266-esp-01)
      - [WEMOS D1 MINI](#wemos-d1-mini)
    - [ESP32](#esp32)
      - [ESP32 DevKit](#esp32-devkit)

---------------

## Teensy
<img src="https://forum.pjrc.com/teensy40_front.jpg" width="300">

https://www.pjrc.com/teensy/

### Getting Started
- **Teensyduino** is an extension of the Arduino IDE that integrats all suppoert and libraries. download here:
 https://www.pjrc.com/teensy/td_download.html


### Audio
- Teensy Audio Library – https://www.pjrc.com/teensy/td_libs_Audio.html
- Audio Library GitHub – https://github.com/PaulStoffregen/Audio
- Audio System Design Tool – https://www.pjrc.com/teensy/gui/
- Audio Shield – https://www.pjrc.com/store/teensy3_audio.html
- Audio Tutorial – https://www.pjrc.com/store/audio_tutorial_kit.html
- Teensy Audio without the Shield - Using ADC, DAC, DUAL PWM 
https://www.youtube.com/watch?v=-2B4Dmy4J1Y
 

### WIFI Extension
- https://www.tindie.com/products/cburgess129/arduino-teensy4-teensy-40-expansion-board/

### Building a Synth with Teensy
- TEENSY-Synth PART 1: BUILD IT – https://www.youtube.com/watch?v=UJcZxyB5rVc
- TEENSY-Synth PART 2: PURE DATA – https://www.youtube.com/watch?v=qWd60HWCCVI
- TEENSY-Synth PART 3: KEYBOARD – https://www.youtube.com/watch?v=IoADj8dvTQc
- TEENSY-Synth PART 4: ADSR – https://www.youtube.com/watch?v=wHkcb9NAnzs
- TEENSY-Synth PART 5: WAVEFORMS & DETUNE – https://www.youtube.com/watch?v=RQWKPd6XH54
- TEENSY-Synth PART 6: FILTER – https://www.youtube.com/watch?v=6VDNHlFealo
- TEENSY-Synth PART 7: PITCH BEND – https://www.youtube.com/watch?v=O1TU3DiBy4E
- TEENSY-Synth PART 8: LFO – https://www.youtube.com/watch?v=zphkBTkOIyQ&t=26s
- TEENSY-Synth PART 9: MIDI INPUT – https://www.youtube.com/watch?v=l34CNfwfuIY
- TEENSY-Synth PART 10: HARDWARE – https://www.youtube.com/watch?v=Inwbu9DgVeU
- TEENSY-Synth PART 11: ENCLOSURE – https://www.youtube.com/watch?v=n6PceuBUDh4

### Example Audio Projects
- Teensymoog
  - https://hackaday.io/project/170474-teensymoog
  - https://github.com/troisiemetype/teensymoog
- Teensy-Midi-Euclidean-Sequencer – https://github.com/mortonkopf/Teensy-Midi-Euclidean-Sequencer
- SENSEI – Multidimensional Sound Synthesizer
  - https://www.pjrc.com/sensei-multidimensional-sound-synthesizer/
- Polaron is a DIY digital drum machine
  - https://github.com/zueblin/Polaron
   
------------

## DAISY Board
<img src="https://images.squarespace-cdn.com/content/v1/58d03fdc1b10e3bf442567b8/1591827747342-HCXMM2NNR26SP5F4U2CJ/ke17ZwdGBToddI8pDm48kN5PbQBGNYbW-5Hm1pf8hRF7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0kLp48N9LluBiCpBrPZntaz462IffsVrAff3VJkwKncM1HZuDnV98dfxM9yHlqFkUQ/DaisyPinoutRev4%404x.png?format=500w" width="300">

https://www.electro-smith.com/daisy/daisy

------------

## AXOLOTI Board

> Axoloti consists of both hardware and software which work together to provide a virtual modular environment.

<img src="http://www.axoloti.com/wp-content/uploads/2013/12/IMG_1117_whitebg.jpg" width="500">

http://www.axoloti.com/

- specialized microcontroller for audio and sensor input; 
- free patch-based editor, load patches via USB; Opcodes extensible via Assembler-like code. 
- Stereo I/O, MIDI I/O, SD card slot, USB MIDI Host onboard.
- rather low price for the integrated HW, free SW. 

------------
## BELA
![BELA Board](https://bela.io/images/products/bela.png "BELA")
https://bela.io

+ Addon Board for Linux based Beaglebone single-board-computers (similar to Paspi) with higly optimized audio I/O for very low latency, many channels supported. Direct, high-res Analog Sensor inputs: 
Well suited for fast reacting devices programmed in high-level prog. languages like 
  - PD
  - SC
  - C++
  - Faust
  Integrated Browser-based IDE for C++ and SC. 
- rather expensive
- [TRILL](https://bela.io/products/trill/) is a set of great hi-res capacitive sensors (not only) for Bela.
- [Project archive](https://blog.bela.io/archive/)

------------

## Raspberry Pi
<img src="https://www.raspberrypi.org/homepage-9df4b/static/raspberry-pi-4-labelled@2x-c1a040c7511610e7274e388432a458c4.png" width="100%">

https://www.raspberrypi.org/

Best supported Linux based single-board-computer - huge ecosystem in HW and SW, huge amount of tutorials, magazines... 
Dozens of pre-formatted [ Linux-Images](https://www.reddit.com/r/raspberry_pi/comments/5p8c9p/list_of_all_raspberry_pi_images_from_around_the/) available for specific purposes; several of them optimized for audio with many music/audio apps pre-installed and drivers optimized for low-latency (realtime kernel...): 

- Blokas patchbox-os https://blokas.io/patchbox-os/
- MODEP https://blokas.io/modep/ Play around with hundreds of LV2 audio plugins.
- [norns image](https://github.com/FigrHed/Norns-on-Raspberry-pi) from the [monome/norns](https://monome.org/) community 

Usually, needs dedicated Audio Interfaces, as internal sound is lousy:

- Class Compiant USB interfaces
overview (maybe not very fresh): https://wiki.linuxaudio.org/wiki/hardware_support
- I2S daughterboards available from many small manufacturers: 
    - [hifiberry](https://www.hifiberry.com/) - also "pro" variant in steel case with XLR plugs
    - [pisound](https://blokas.io/pisound/) (matched to patchbox-os)
    - overview: https://elinux.org/index.php?title=RPi_Expansion_Boards#Sound 

------------
## ESP Series
Popular, "new" Series of inexpensive Single-Board-computers targeted at IoT, Arduino compatible but with modern 32bit processor similar to Teensy, and WiFi & Bluetooth onboard (!), designed & made by chinese company ESPRESSIF. 
Large support base online, but not as good as for Arduino. 
Well suited for inexpensive sensor devices that communicate via wireless OSC. 
Capable of audio playback and synthesis with appropriate (I2S) DACs, but esp. the latter is rather poorly documented. 

#### Example Audio Projects
- drum machine https://zircothc.wordpress.com/
- many [audio player projects](https://www.youtube.com/results?search_query=ESP8266+audio+player)

### ESP8266
Smallest, most inexpensive chip from the ESP series; as cheap as <2€ per chip from Chinese sources! Think of large-scale use cases!-) 
With only 1 ADC pin hardly suited for analog sensors, but fine for any peripherals commuicating via I2C / SPI bus. 

#### ESP8266 ESP-01
<img src="https://ae01.alicdn.com/kf/HTB1mwr2NFXXXXc4XpXXq6xXFXXXn/ESP8266-ESP-01-ESP8266-WIFI-module-Serial-Wi-Fi-Wireless-Transceiver-Module-for-Arduino.jpg" width="200">

smallest footprint, best for miniaturization/low energy projects. 


#### WEMOS D1 MINI 
<img src="https://docs.wemos.cc/en/latest/_images/d1_mini_v3.1.0_1_16x16.jpg" width="200">

larger, Breadboard-friendly version with 16 Pins: https://docs.wemos.cc/en/latest/d1/d1_mini.html.
<br> Many inexpensive add-on sensorboards available from producer [Wemos](https://www.wemos.cc/en/latest/d1_mini_shield/index.html). 

### ESP32

2nd generation; more powerful, many more GPIO's. 

#### ESP32 DevKit 
<img src="https://www.olimex.com/Products/IoT/ESP32/ESP32-DevKit-LiPo/images/ESP32-DevKit-LiPo.jpg" width="200">

[Olimex Version](https://www.exp-tech.de/plattformen/esp32/) includes Li-Po accu charging circuit > very well suited for portable wireless applications.



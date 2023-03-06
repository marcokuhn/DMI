
# DMI –  Protocols

- [DMI –  Protocols](#dmi---protocols)
  - [MIDI – Musical Instrument Digital Interface](#midi--musical-instrument-digital-interface)
    - [HISTORY](#history)
    - [DATA TRANSMISSION](#data-transmission)
      - [STRUCTURE OF A MESSAGE](#structure-of-a-message)
    - [MIDI INTERFACES](#midi-interfaces)
    - [TOOLS](#tools)
    - [LINKS](#links)
  - [OSC – Open Sound Control Protocol](#osc--open-sound-control-protocol)
    - [Examples use cases](#examples-use-cases)
      - [Local communication](#local-communication)
      - [Remote control](#remote-control)
      - [Communication between computers](#communication-between-computers)
    - [OSC data transmission](#osc-data-transmission)
    - [Data types in OSC](#data-types-in-osc)
    - [OSC messages](#osc-messages)
    - [implementations:](#implementations)
  - [- OSC via USB: Node JS script that translates SLIP OSC to UDP OSC (bidirectional): https://github.com/tttapa/Projects/tree/master/Arduino/NodeJS/SLIP](#--osc-via-usb-node-js-script-that-translates-slip-osc-to-udp-osc-bidirectional-httpsgithubcomtttapaprojectstreemasterarduinonodejsslip)
    - [OSC vs. MIDI](#osc-vs-midi)
      - [Pros](#pros)
      - [Cons](#cons)
    - [Network Introduction](#network-introduction)
      - [My Local IP-Address](#my-local-ip-address)
    - [Links](#links-1)
  - [USB HID](#usb-hid)
      - [Pros](#pros-1)
      - [Cons](#cons-1)
      - [HID on Teensy](#hid-on-teensy)


## MIDI – Musical Instrument Digital Interface

<img src="https://upload.wikimedia.org/wikipedia/commons/2/20/Midi.png" width="250">

### HISTORY
- MIDI - Musical Instrument Digital Interface is a specification how to transmit digital control information
- MIDI 1.0 was introduced in 1982 by Dave Smith and Ikutaro Kakehashi (Founder of Roland Corporation)

### DATA TRANSMISSION

Data is transfered serially at Baud rate 31250 bits/sec. 
This may cause lags if large amounts of data are to be transmitted at once. 

#### STRUCTURE OF A MESSAGE
A message consists of 3 bytes
- 1 status byte and 2 data bytes
<img src="http://digitalsoundandmusic.com/wp-content/uploads/2014/05/Figure-6.16-Note-On-message-with-data-bytes.png" width="300">

e.g. NOTE ON Message </br>
9n = StatusByte = NOTE-ON messge (n = MIDI channel 0 - 15)
1. data byte = note (0 - 127 )
2. data byte = velocity (0 - 127)

To distinguish between a status byte and a data byte, a status byte always
begins with 1 and a data byte with 0.</br></br>
Summary of MIDI Messages
https://www.midi.org/specifications-old/item/table-1-summary-of-midimessage

### MIDI INTERFACES
MIDI 5-pin DIN sockets</br>
<img src="https://www.pjrc.com/teensy/td_libs_MIDI_sch_t3.png" width="400">
- MIDI-In is used by a device to receive messages. Usually decoupled by an Optocoupler for safety. 
- MIDI Out transmits messages
- MIDI-Thru transmits unprocessed signals received at the MIDI-In
- MIDI over USB. Dedicated article: https://tttapa.github.io/Control-Surface-doc/Doxygen/d8/d4a/md_pages_MIDI-over-USB.html 
- MIDI OVER LAN
- Wireless MIDI: rtpMIDI, AppleMIDI, MIDI over BLE (Bluetooth), ... 

### TOOLS
- MIDI Monitor – http://www.snoize.com/MIDIMonitor/
- SysEx Librarian – http://www.snoize.com/SysExLibrarian/
- Hairless MIDI<->Serial Bridge – https://projectgus.github.io/hairless-midiserial/

### LINKS
- https://learn.sparkfun.com/tutorials/midi-tutorial/all
- https://www.midi.org

----------------------------------------------
----------------------------------------------

## OSC – Open Sound Control Protocol

- a network communication protocol
- used to transmit control data via a network (Internet, local network, WLAN)
- can also exchange data between programs locally on one computer (localhost)
- often used as a modern replacement for MIDI
  
Project page : http://opensoundcontrol.org/introduction-osc

### Examples use cases

#### Local communication
- AV Performance -> Sound connected to Visuals: Ableton Live <-> Resolume
- gesture controller -> MYO controls Ableton Live parameter -> http://
audiodesign.hdpk.de/?works=kontraktion

#### Remote control
- Mobile Phone controls computer e.g. TouchOSC, Lemur
- Dedicated Ableton Live Controller e.g. TouchAble

#### Communication between computers
- Sound environment (e.g. Max for Live / SC) controls Visuals (VVVV) on another computer in the sam network or
- via computer in different networks (Internet through a tunnel e.g. ngrok https://ngrok.com)

### OSC data transmission

OSC specification: http://opensoundcontrol.org/introduction-osc

Data will be transmitted through packages. A package consists of data and a byte, which specifies the length of the transmitted message. The package will be transmitted through UDP or TCP.

### Data types in OSC 

- int32
- float32
- OSCString, sequence of ASCII characters
- OSCBlob
- OSCTimetag (64 bit). The first 32 bits are the seconds since 1 January 1900, the second 32 bits represent the second fraction, this is the NTP format.

### OSC messages

- consists of a path (address / represents the value to be transmitted) and the parameters to be transmitted
  
e.g. 
````````````
    /track/1/volume 0.75
    /collision/1 1
    /tab1/slider1/value 0.33
````````````

### implementations:
- Aruino OSC library: https://github.com/CNMAT/OSC
- OSC via USB: Node JS script that translates SLIP OSC to UDP OSC (bidirectional): https://github.com/tttapa/Projects/tree/master/Arduino/NodeJS/SLIP 
---------------------------

### OSC vs. MIDI

#### Pros
- faster data transfer - max. is network datatransmission rate
- datatype is not limited to 7-bit - supports Int, float, complex data types - http://opensoundcontrol.org/spec-1_0
- OSC is sent over the network (Internet, Wlan)
- no MIDI hardware necessary, network is usually available
- you can define own data types
- Integration and control of hardware is easier than MIDI SysEx messages

#### Cons
- No standardization of the parameters as with the MIDI protocol (e.g. Note-On,CC,...)
- Address (sender and receiver need to make an handshake) 
- Value range (0 - 127)
- Not backward compatible to MIDI

### Network Introduction
- Every computer in the network has an IP address. It will be assigned as soon as you connect to a network
- each address has ports (channels). Communication takes place over these ports. For OSC Select an unreserved port e.g. > 9000.
- A firewall can block certain ports. Make sure that the OSC ports are not blocked.
- **Note: Sender and receiver need to be in the same network and are communication over the same port**
 

#### My Local IP-Address
<img src="https://cdn.osxdaily.com/wp-content/uploads/2010/11/ip-address-mac-610x206.jpg" width="400">

- Open Mac > System Control > Network
- Open Terminal > Ifconfig

### Links
- OSC - http://opensoundcontrol.org
- Tunnel for sending data over different networks (internet) - https://ngrok.com
- TCP OSC Router https://github.com/bgola/tcposcrouter
- Max/Msp - ([OSC-Route],[o.route])
  - https://cnmat.berkeley.edu/downloads
  - ODOT (ODOT (OSC) objects)
  - OSC-Route (CNMAT Externals) 
- OSC ARDUINO / TEENSY / ESP8266 Library
  - https://github.com/CNMAT/OSC


## USB HID
Human Interface Device - The way the USB Port handles input devices from Mouse/KB to Joysticks, Gaming to medical assistance devices. 

#### Pros
- highly robust, plug&play wired interface
- cross platform: works automatically with built-in drivers. 
- can transmit 64byte packages - best for high-res. sensor data, where MIDI's 7 bit are often too coarse. 
- MAX./PD/SC and more SW toolkits can read generic HID
- emulate Gamepads etc.
- Teensy supports USB Modes for both MIDI and HID, as well as Keyboard and Mouse Emulation. 

#### Cons
- difficult, rather intransparent protocol
- only recommendable where sending double byte MIDI data is not convenient. 

#### HID on Teensy
- https://www.pjrc.com/teensy/rawhid.html 
- tutorial: https://www.kobakant.at/DIY/?p=2497

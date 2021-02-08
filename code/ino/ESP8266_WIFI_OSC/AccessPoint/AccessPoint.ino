/*---------------------------------------------------------------------------------------------
  CODE From https://github.com/CNMAT/OSC
  
  Open Sound Control (OSC) library for the ESP8266/ESP32
  This example code is in the public domain.

--------------------------------------------------------------------------------------------- */
  
#include <ESP8266WiFi.h>        // Include the Wi-Fi library

#include <WiFiUdp.h>
#include <OSCMessage.h>
#include <OSCBundle.h>
#include <OSCData.h>

const char *ssid = "ESP8266_Access_Point"; // The name of the Wi-Fi network that will be created
const char *password = "OneTwoSix";   // The password required to connect to it, leave blank for an open network

// A UDP instance to let us send and receive packets over UDP
WiFiUDP Udp;
const unsigned int localPort = 8888;        // local port to listen for UDP packets (here's where we send the packets)

OSCErrorCode error;

void setup() {
  Serial.begin(115200);
  delay(10);
  Serial.println('\n');

  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, password);
  Serial.println("Wait 100 ms for AP_START...");
  delay(100);

  Serial.println("Set softAPConfig");
  IPAddress Ip(192, 168, 4, 1);
  IPAddress NMask(255, 255, 255, 0);
  WiFi.softAPConfig(Ip, Ip, NMask);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);

  Serial.println("Starting UDP");
  Udp.begin(localPort);
  Serial.print("Listen To Local port: ");
  Serial.println(localPort);

  pinMode(BUILTIN_LED, OUTPUT);
  // Connect D0 to RST to wake up
  pinMode(D0, WAKEUP_PULLUP);


}

void toggleLED(OSCMessage &msg) {
  int value = (int)msg.getFloat(0);
  //int value = msg.getInt(0);

  if (value == 1) {
    digitalWrite(BUILTIN_LED, HIGH);
  } else {
    digitalWrite(BUILTIN_LED, LOW);
  }
  Serial.print("/receive toggleLED: ");
  Serial.println(value);
}

void loop() {

  OSCMessage msg;
  int size = Udp.parsePacket();

  if (size > 0) {
    while (size--) {
      msg.fill(Udp.read());
    }
    if (!msg.hasError()) {
      msg.dispatch("/1/toggle1", toggleLED);
    } else {
      error = msg.getError();
      Serial.print("error: ");
      Serial.println(error);
    }
  }
}

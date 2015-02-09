/*
  Connecting to NYUs different networks

  This sketch makes it easy to swap Wi-Fi
  networks at ITP between the itpsandbox and
  nyu network

 created 5 Feb 2015
 by Surya Mattu

 This code is a modified version of the Wi-Fi check example sketch
 Please read the README for more information.

 http://github.com/samatt/

 */

//If using nyu you need to add this file to your sketch folder
// Please refer to the readme for more information
#include "nyucreds.h"
#include <Process.h>

String mode = "nyu";    //use this for sandbox
//String mode = "nyu";            //use this for nyu

void setup() {
  Serial.begin(9600);
  while (!Serial);
  
  Serial.println("Starting bridge...\n");
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  Bridge.begin();
  digitalWrite(13, HIGH);
  delay(2000);

}

void loop() {
  String result = checkNetworkStatus();
  
  //If connected to itpsandbox and mode is set to NYU switch the network
  if (result == "SSID: itpsandbox\n" && mode == "nyu") {
    Serial.println("Switching to NYU!");
    switchToNyu();
  }
  //Vice versa
  else if (result == "SSID: nyu\n" && mode == "itpsandbox") {
    Serial.println("Switching to itpsandbox!");
    switchToSanbox();
  }
  delay(5000);

}

String checkNetworkStatus() {
  Process wifiCheck;
  wifiCheck.runShellCommand("/usr/bin/pretty-wifi-info.lua | grep SSID:");
  String result = "";
  while (wifiCheck.available() > 0) {
    char c = wifiCheck.read();
    result += c;
    Serial.print(c);
  }
  return result;
}

void switchToSanbox() {
  
  Process p;
  // Execute Shell script from SD card with sandbox param
  p.runShellCommand("/mnt/sda1/configure.sh itpsandbox");
  while (p.running());
  
  String result = "";
  while (p.available() > 0) {
    char inChar = p.read();
    result += inChar;
    Serial.print(result);
    Serial.println(inChar);
  }
  Serial.println(result);

}

void switchToNyu() {
  Process p;
  // Execute Shell script from SD card with nyu params
  String command = "/mnt/sda1/configure.sh nyu";
  
  //username and password are your nyu netid and password
  // This should be in a file called nyucreds.h 
  // and NEVER show anyone that file
  String execute = command + " " + username + " " + password;
  
  p.runShellCommand(execute);

  while (p.running());
  String result = "no result";
  while (p.available() > 0) {
    char inChar = p.read();
    Serial.println(inChar);
    result += inChar;
  }
  Serial.println(result);

}

  //  Process cd;
  //  cd.runShellCommand( "cd /root/network_config");
  //  while (cd.running());
  //  while (cd.available() > 0) {
  //    char inChar = cd.read();
  //    Serial.print(inChar);
  //  }

  //  Process pwd;
  //  pwd.runShellCommand( "pwd");
  //  while (pwd.running());
  //  while (pwd.available() > 0) {
  //    char inChar = pwd.read();
  //    Serial.print(inChar);
  //  }

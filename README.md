#Yun-Wifi-Switch
##What is this for?
Setting up the Yun to work on nyu Wi-Fi and itpsandbox.	
The instructions and the code in this repo are designed to make it easy to switch between NYUs Enterprise network and ITPs sandbox which is a WPA2 network. They are a programmatic version of Karl Wards  [Connected Devices notes](https://docs.google.com/a/nyu.edu/document/d/1sjEuz2kvg2WL44x1hwZIBAjGs43VIdOoVGXu-KWVBUE/edit#heading=h.1aj49wws2mc)


##Prequisites

The first time you setup your Yun go through the normal instructions to do a system upgrade of the Yun. This can be done by following the instructions at [this link](http://arduino.cc/en/Tutorial/YunSysupgrade).

Along with Sys Upgrade be sure to set the **system clock with the right time zone** through the web interface. It is really important to do this. If your clock is way off from the current time (by default it is set to 2011) NYUs 802.1X network will deauthenticate your device.

If using the Yun on itpsandbox you should register the device on the [NYU computer registration page](https://computer.registration.nyu.edu/register.php).

##How to set it up

The Yun stores your network preferences on the Linino side in a file called `wireless` full path is `/etc/config/wireless`. 
You can view your settings by executing the following command:

`sudo less /etc/config/wireless`

This repository contains two versions of this wireless config file. They can be found at in the `config_files/` folder. One of them is for connecting to the *itpsandbox* and the other is for connecting to *nyu*. In order to get your Yun to switch networks it is necessary to swap the wireless config file with one of the files in this repository. 

###Copy the files to an SD Card
In order to be able to do any of this you need to take the files from the `SD Card Folder` in this repo and copy them onto a miniSD that you then connect to your Yun. Once you have copied the files you can change the network in one of two ways.

###Using the Arduino Sketch
This repository contains an Arduino sketch which you can use to swap the files. 
Copy `NyuNetworkSketch` to your Arduino sketch folder.
Once you have copied it, open the .ino file. In order to set the correct network you need to set the mode and your credentials.

---
**Important** : 
 Connecting to NYU requires your netid and password. The Yun also needs this information in order to connect to NYU. To make this step safer the setup requires you to add a new file called `nyucreds.h`. This file should be in `NyuNetworkSketch` and  should have the following parameters
 

```
#define username  "netid"
#define password "password"
```
  
**Your username and password will be stored in PLAIN TEXT** on the Yun in `/etc/config/wireless` If you are using someone else's yun or one from  the ER please be sure to remove your information from it by connecting back to *itpsandbox*

---

Once you have added the `nyucreds.h` you can set the mode by uncommenting one of the following lines in `NyuNetworkSketch.ino`:

```
String mode = "itpsanbox";    //use this for sandbox
String mode = "nyu";            //use this for nyu
```

Compile and run the sketch and you should see the following outpt:



###Advanced method

In case you don't want to use the sketch and want to do this manually instead you still need to copy the `SD_CARD` folder to the Yun. Once copied look at `configure.sh`. This is what the sketch calls and it contains the linux commands to copy the files to the right place.

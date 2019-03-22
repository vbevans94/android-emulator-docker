# docker-android
Dockerfile with Android SDK and some tools

### Currently installed Android 7.1.1 and latest SDK on Feb 2019

## Setup guide:

### With device - Linux only

Put dockerized_device.sh into your project root folder

Plug-in device
```
> sudo apt-get install adb
> adb devices
# copy the device id
# accept on device system dialog to save adbkeys
./dockerized_device.sh "./gradlew cAT" <device_id>
```

### With emulator

Put dockerized_emulator.sh into your project root folder

Install Android SDK

Create and run AVD
```
./dockerized_emulator.sh "./gradlew cAT"
```

In case you have multiple AVDs you can specify port, e.g.:

```
./dockerized_emulator.sh "./gradlew cAT" 5557
```

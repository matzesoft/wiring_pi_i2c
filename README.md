# Wiring Pi I2C

Dart implementation of the Wiring Pi I2C library.

I mainly created this package for one of my own projects, so I haven't done a lot of testing yet. But I still hope this makes the creation of your flutter-pi app (or whatever you create) easier.

## Installing Wiring Pi

Visit this [guide](http://wiringpi.com/download-and-install/) to install the Wiring Pi library on your Raspberry Pi. If your are using a Raspberry Pi 4B you might also check this [post](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).

## Using the package

The first thing you always want to do is to create the `I2CInterface`. You can specific a path to the dynamic library, the default path is `/usr/lib/libwiringPi.so`.
```dart
final i2cInterface = I2CInterface(path: '/path/to/library.so');
```

Now create the `I2CDevice`. It takes the `I2CInterface` created before and the address of the I2C device. You can find this address by using the command `sudo i2cdetect -y 1`. Afterwards call the `setup` method.
```dart
final addr = 0x48;
final i2cDevice = I2CDevice(i2cInterface, addr);
i2cDevice.setup();
```

The `I2CDevice` is setup and ready to use. You can use all the commands mentioned in the [Wiring Pi documentation](http://wiringpi.com/reference/i2c-library/).
```dart
final register = 0x01;
final value = 0x8000;
i2cDevice.writeReg16(register, value);

final output = i2cDevice.readReg16(register);
print("Value of register $register: $output");
```

If any of the methods fails a `I2CException` will be throwen.

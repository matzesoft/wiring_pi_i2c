import 'dart:ffi';
import 'dart:io';

/// Documentation is copied from `http://wiringpi.com/reference/i2c-library/`(19.01.2021, 11:58 CET).

/// WiringPi Native: `int wiringPiI2CSetup(int devId);`
typedef wiring_pi_i2c_setup = Int32 Function(Int32 devId);
typedef WiringPiI2CSetup = int Function(int devId);

/// WiringPi Native: `int wiringPiI2CRead(int fd);`
typedef wiring_pi_i2c_read = Int32 Function(Int32 fd);
typedef WiringPiI2CRead = int Function(int fd);

/// WiringPi Native: `int wiringPiI2CWrite(int fd, int data);`
typedef wiring_pi_i2c_write = Int32 Function(Int32 fd, Int32 data);
typedef WiringPiI2CWrite = int Function(int fd, int data);

/// WiringPi Native: `int wiringPiI2CWriteReg8(int fd, int reg, int data);`
typedef wiring_pi_i2c_write_reg8 = Int32 Function(
    Int32 fd, Int32 reg, Int32 data);
typedef WiringPiI2CWriteReg8 = int Function(int fd, int reg, int data);

/// WiringPi Native: `int wiringPiI2CWriteReg16(int fd, int reg, int data);`
typedef wiring_pi_i2c_write_reg16 = Int32 Function(
    Int32 fd, Int32 reg, Int32 data);
typedef WiringPiI2CWriteReg16 = int Function(int fd, int reg, int data);

/// WiringPi Native: `int wiringPiI2CReadReg8(int fd, int reg);`
typedef wiring_pi_i2c_read_reg8 = Int32 Function(Int32 fd, Int32 reg);
typedef WiringPiI2CReadReg8 = int Function(int fd, int reg);

/// WiringPi Native: `int wiringPiI2CReadReg16(int fd, int reg);`
typedef wiring_pi_i2c_read_reg16 = Int32 Function(Int32 fd, Int32 reg);
typedef WiringPiI2CReadReg16 = int Function(int fd, int reg);

class I2CNative {
  DynamicLibrary _dylib;

  /// This initialises the I2C system with your given device identifier. The ID
  /// is the I2C number of the device and you can use the i2cdetect program to
  /// find this out. wiringPiI2CSetup() will work out which revision Raspberry Pi
  /// you have and open the appropriate device in /dev.
  WiringPiI2CSetup setupI2C;

  /// Simple device read. Some devices present data when you read them without
  /// having to do any register transactions.
  WiringPiI2CRead readI2C;

  /// Simple device write. Some devices accept data this way without needing to
  /// access any internal registers.
  WiringPiI2CWrite writeI2C;

  /// Write an 8-Bit or 16-bit data value into the device register indicated.
  WiringPiI2CWriteReg8 writeReg8;
  WiringPiI2CWriteReg16 writeReg16;

  /// Read an 8-Bit or 16-bit value from the device register indicated.
  WiringPiI2CReadReg8 readReg8;
  WiringPiI2CReadReg16 readReg16;

  /// Opens the dynamic library and looks up all Functions.
  I2CNative(String path) {
    try {
      _dylib = DynamicLibrary.open(path);
    } on ArgumentError catch (_) {
      throw FileSystemException(
        """
        Unable to open the Wiring Pi dynamic library at the path '$path'. Check
        if you installed Wiring Pi correctly (http://wiringpi.com/download-and-install/).
        If you are using the Raspberry Pi 4B you might have to manually upgrade
        to version 2.52 (http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).
        """,
        path,
      );
    }

    setupI2C = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_setup>>('wiringPiI2CSetup')
        .asFunction<WiringPiI2CSetup>();
    readI2C = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_read>>('wiringPiI2CRead')
        .asFunction<WiringPiI2CRead>();
    writeI2C = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_write>>('wiringPiI2CWrite')
        .asFunction<WiringPiI2CWrite>();
    writeReg8 = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_write_reg8>>(
            'wiringPiI2CWriteReg8')
        .asFunction<WiringPiI2CWriteReg8>();
    writeReg16 = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_write_reg16>>(
            'wiringPiI2CWriteReg16')
        .asFunction<WiringPiI2CWriteReg16>();
    readReg8 = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_read_reg8>>('wiringPiI2CReadReg8')
        .asFunction<WiringPiI2CReadReg8>();
    readReg16 = _dylib
        .lookup<NativeFunction<wiring_pi_i2c_read_reg16>>(
            'wiringPiI2CReadReg16')
        .asFunction<WiringPiI2CReadReg16>();
  }
}

import 'package:wiring_pi_i2c/src/i2c_native.dart';

/// Default path of the Wiring Pi library.
const String _defaultPath = '/usr/lib/libwiringPi.so';

/// Holds the instance of the Wiring Pi library.
class I2CInterface {
  I2CNative _native;

  /// Opens the Wiring Pi library. The [path] should point to the `.so` file.
  /// The default path is `/usr/lib/libwiringPi.so`.
  ///
  /// Check http://wiringpi.com/download-and-install/ on more information how
  /// to install Wiring Pi correctly.
  /// If you are using the Raspberry Pi 4B you might have to manually upgrade
  /// to version 2.52 (http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/).
  I2CInterface({String path: _defaultPath}) {
    _native = I2CNative(path);
  }
}

class I2CDevice {
  I2CNative _native;
  int _addr;

  /// Linux file descriptor for the I2C device.
  int _deviceIdentifier = -1;

  /// Takes a instance of the [I2CInterface] class. [addr] defines the address
  /// of the device on the bus. You can find this address by using the command
  /// `sudo i2cdetect -y 1`.
  ///
  /// To use the I2C device you must call the [setup] method.
  I2CDevice(I2CInterface i2c, int addr) {
    this._addr = addr;
    this._native = i2c._native;
  }

  /// Address on the I2C Bus of the device.
  int get addr => _addr;

  /// Sets up the I2C device. Throws an [I2CException] when failed.
  void setup() {
    final fd = _native.setupI2C(addr);
    if (fd < 0) throw I2CException("Failed to setup the I2C device.", addr);
    _deviceIdentifier = fd;
  }

  /// Reads from the device without specifying the register. Throws an
  /// [I2CException] when failed.
  int read() {
    _checkIfSetup();
    final output = _native.readI2C(_deviceIdentifier);
    if (output < 0) throw I2CException("Failed to read from I2C device.", addr);
    return output;
  }

  /// Writes to the device without specifying the register. Throws an
  /// [I2CException] when failed.
  void write(int value) {
    _checkIfSetup();
    final output = _native.writeI2C(_deviceIdentifier, value);
    if (output < 0) throw I2CException("Failed to write to I2C device.", addr);
  }

  /// Reads a 8-Bit register from the device. Throws an [I2CException] when failed.
  int readReg8(int reg) {
    _checkIfSetup();
    final output = _native.readReg8(_deviceIdentifier, reg);
    if (output < 0) {
      throw I2CException(
        "Failed to write from 8-Bit Register '$reg' on I2C device.",
        addr,
      );
    }
    return output;
  }

  /// Reads a 16-Bit register from the device. Throws an [I2CException] when failed.
  int readReg16(int reg) {
    _checkIfSetup();
    final output = _native.readReg16(_deviceIdentifier, reg);
    if (output < 0) {
      throw I2CException(
        "Failed to read from 16-Bit Register '$reg' on I2C device.",
        addr,
      );
    }
    return output;
  }

  /// Writes to an 8-Bit register to the device. Throws an [I2CException] when failed.
  void writeReg8(int reg, int value) {
    _checkIfSetup();
    // TODO: Check for values longer than 8-Bit
    final output = _native.writeReg8(_deviceIdentifier, reg, value);
    if (output < 0)
      throw I2CException(
        "Failed to write to 8-Bit Register '$reg' on I2C device.",
        addr,
      );
  }

  /// Writes to an 16-Bit register to the device. Throws an [I2CException] when failed.
  void writeReg16(int reg, int value) {
    _checkIfSetup();
    // TODO: Check for values longer than 16-Bit
    final output = _native.writeReg16(_deviceIdentifier, reg, value);
    if (output < 0)
      throw I2CException(
        "Failed to write to 16-Bit Register '$reg' on I2C device.",
        addr,
      );
  }

  /// Checks if the [_deviceIdentifier] is negativ and throws a [StateError]
  /// when true.
  void _checkIfSetup() {
    if (_deviceIdentifier < 0)
      throw StateError(
        """
        I2C device has not yet been setup. You must call the 'setup' method
        before using the device. Device address: $addr
        """,
      );
  }
}

class I2CException implements Exception {
  final String _message;
  final int _addr;

  I2CException(this._message, this._addr);

  @override
  String toString() => "$_message (Addr: $_addr)";
}

import 'package:wiring_pi_i2c/src/i2c_native.dart';

class I2CDevice {
  /// [addr] defines the address of the device on the bus. You can find this
  /// address by using the command `sudo i2cdetect -y 1`.
  ///
  /// To use the I2C device you must call the [setup] method.
  I2CDevice(this._addr);

  static I2CNative _native = I2CNative();
  int _addr;

  /// Linux file descriptor for the I2C device.
  int _deviceIdentifier = -1;

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
    final data = _native.readReg16(_deviceIdentifier, reg);
    if (data < 0) {
      throw I2CException(
        "Failed to read from 16-Bit Register '$reg' on I2C device.",
        addr,
      );
    }
  
    // Due to a WiringPi issue msb and lsb must be switched around.
    final msb = (data << 8);
    final lsb = (data >> 8);
    final output = (msb | lsb) & 0xFFFF;

    return output;
  }

  /// Writes to an 8-Bit register to the device. Throws an [I2CException] when failed.
  void writeReg8(int reg, int value) {
    _checkIfSetup();
    if (value > 0xFF) throw ArgumentError("value must be 8-Bit long.");

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
    if (value > 0xFFFF) throw ArgumentError("value must be 16-Bit long.");

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

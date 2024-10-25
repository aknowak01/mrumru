import 'package:equatable/equatable.dart';

/// Represents the protocol type used in the data transfer.
class ProtocolType extends Equatable {
  /// Static instance representing raw data transfer.
  static ProtocolType rawDataTransfer = const ProtocolType.custom(0);

  /// Static instance representing calibration test.
  static ProtocolType calibrationTest = const ProtocolType.custom(1);

  /// Static instance representing simple handshake.
  static ProtocolType simpleHandshake = const ProtocolType.custom(2);

  /// Static instance representing end-to-end encryption.
  static ProtocolType endToEndEncryption = const ProtocolType.custom(3);

  /// Static instance representing partially received data.
  static ProtocolType dataPartiallyReceived = const ProtocolType.custom(4);

  /// Static instance representing all data received.
  static ProtocolType allDataReceived = const ProtocolType.custom(5);

  /// Static instance representing failed to receive data.
  static ProtocolType failedToReceiveData = const ProtocolType.custom(6);

  /// Value representing the protocol type.
  final int value;

  /// Creates a new instance of [ProtocolType] for custom use.
  const ProtocolType.custom(this.value);

  @override
  List<Object> get props => <Object>[value];
}

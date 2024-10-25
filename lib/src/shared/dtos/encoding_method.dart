import 'package:equatable/equatable.dart';

/// Represents the encoding method used in the data transfer.
class EncodingMethod extends Equatable {
  /// Static instance representing no encoding.
  static EncodingMethod raw = const EncodingMethod.custom(0);

  /// Value representing the encoding method.
  final int value;

  /// Creates a new instance of [EncodingMethod] for custom use.
  const EncodingMethod.custom(this.value);

  @override
  List<Object> get props => <Object>[value];
}

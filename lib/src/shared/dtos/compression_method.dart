import 'package:equatable/equatable.dart';

/// Represents the compression method used in the data transfer.
class CompressionMethod extends Equatable {
  /// Static instance representing no compression.
  static CompressionMethod noCompression = const CompressionMethod.custom(0);

  /// Static instance representing 1st level zip compression.
  static CompressionMethod zipFastest = const CompressionMethod.custom(1);

  /// Static instance representing 6th level zip compression.
  static CompressionMethod zipDefault = const CompressionMethod.custom(2);

  /// Static instance representing 9th level zip compression.
  static CompressionMethod zipMax = const CompressionMethod.custom(3);

  /// Value representing the compression method.
  final int value;

  /// Creates a new instance of [CompressionMethod] for custom use.
  const CompressionMethod.custom(this.value);

  @override
  List<Object> get props => <Object>[value];
}

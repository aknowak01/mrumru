import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/dtos/a_base_frame_dto.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

/// A class that represents a decoded [ABaseFrameDto] with a reminder.
class FrameReminder<T extends ABaseFrameDto> extends Equatable {
  /// The decoded [ABaseFrameDto] value.
  final T value;

  /// The remaining unprocessed bytes after decoding the frame.
  final Uint8List reminder;

  /// Creates an instance of [FrameReminder] with the given [value] and [reminder].
  ///
  /// The [value] represents the decoded frame, and [reminder] contains any
  /// leftover bytes not yet processed.
  const FrameReminder({
    required this.value,
    required this.reminder,
  });

  /// The number of bits consumed during the decoding of [value].
  int get bitsConsumed => value.toBytes().length * BinaryUtils.bitsInByte;

  @override
  List<Object?> get props => <Object?>[value, reminder];
}

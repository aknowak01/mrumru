import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';

/// A class that represents a ABaseFrameDto.
abstract class ABaseFrameDto with EquatableMixin {
  /// The index of the frame.
  Uint16 get frameIndex;

  /// The length of the frame.
  Uint16 get frameLength;

  /// The checksum of the frame.
  Uint16 get frameChecksum;

  /// Converts the frame into its binary representation.
  Uint8List toBytes();
}

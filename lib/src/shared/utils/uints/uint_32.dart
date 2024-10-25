import 'dart:typed_data';

import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a [Uint32].
class Uint32 extends UintDynamic {
  /// The size of the [Uint32].
  static const int _bytesSize = 4;
  static const int _bitsSize = 32;

  /// Creates a instance of [Uint32] with the given [bytes].
  Uint32(Uint8List bytes) : super(bytes, _bitsSize);

  /// Creates a instance of [Uint32] from the given [int] value.
  factory Uint32.fromInt(int value) {
    return Uint32(BigIntUtils.encode(BigInt.from(value), _bytesSize));
  }

  /// Creates a instance of [Uint32] from the given [Uint8List] value.
  static UintReminder<Uint32> fromBytes(Uint8List bytes) {
    if (bytes.length < _bytesSize) {
      throw BytesTooShortException('Not enough bytes to create Uint8');
    }
    Uint8List value = bytes.sublist(0, _bytesSize);
    Uint8List reminder = bytes.sublist(_bytesSize);

    return UintReminder<Uint32>(Uint32(value), reminder);
  }
}

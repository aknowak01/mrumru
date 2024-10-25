import 'dart:typed_data';

import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/utils/big_int_utils.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

/// A class that represents a [Uint8].
class Uint8 extends UintDynamic {
  /// The size of the [Uint8].
  static const int _bytesSize = 1;
  static const int _bitsSize = 8;

  /// Creates a instance of [Uint8] with the given [bytes].
  Uint8(Uint8List bytes) : super(bytes, _bitsSize);

  /// Creates a instance of [Uint8] from the given [int] value.
  factory Uint8.fromInt(int value) {
    return Uint8(BigIntUtils.encode(BigInt.from(value), _bytesSize));
  }

  /// Creates a instance of [Uint8] from the given [Uint8List] value.
  static UintReminder<Uint8> fromBytes(Uint8List bytes) {
    if (bytes.length < _bytesSize) {
      throw BytesTooShortException('Not enough bytes to create Uint8');
    }
    Uint8List value = bytes.sublist(0, _bytesSize);
    Uint8List reminder = bytes.sublist(_bytesSize);

    return UintReminder<Uint8>(Uint8(value), reminder);
  }
}

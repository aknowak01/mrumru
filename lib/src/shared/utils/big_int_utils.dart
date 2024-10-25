import 'dart:typed_data';

import 'package:mrumru/src/shared/utils/binary_utils.dart';

/// A class that contains utilities for BigInt.
class BigIntUtils {
  /// Decodes a list of bytes into a BigInt value.
  static BigInt decode(List<int> bytes, {int? bitLength, Endian order = Endian.big}) {
    List<int> tmpBytes = bytes;
    if (order == Endian.little) {
      tmpBytes = List<int>.from(bytes.reversed.toList());
    }

    int bytesBitLength = tmpBytes.length * BinaryUtils.bitsInByte;

    BigInt result = BigInt.zero;
    for (int i = 0; i < tmpBytes.length; i++) {
      result += BigInt.from(tmpBytes[tmpBytes.length - i - 1]) << (BinaryUtils.bitsInByte * i);
    }

    if (bitLength != null && bytesBitLength >= bitLength) {
      result >>= bytesBitLength - bitLength;
    }
    return result;
  }

  /// Encodes a BigInt into a list of bytes.
  static Uint8List encode(BigInt value, int byteLength, {Endian order = Endian.big}) {
    BigInt updatedValue = value;
    BigInt bigMaskEight = BigInt.from(0xff);
    if (updatedValue == BigInt.zero) {
      return Uint8List.fromList(List<int>.filled(byteLength, 0));
    }
    List<int> byteList = List<int>.filled(byteLength, 0);
    for (int i = 0; i < byteLength; i++) {
      byteList[byteLength - i - 1] = (updatedValue & bigMaskEight).toInt();
      updatedValue = updatedValue >> BinaryUtils.bitsInByte;
    }

    if (order == Endian.little) {
      byteList = byteList.reversed.toList();
    }

    return Uint8List.fromList(byteList);
  }
}

import 'dart:typed_data';

/// A class that provides utility methods for binary operations.
class BinaryUtils {
  /// The number of bits in a single byte.
  static const int bitsInByte = 8;

  /// Converts a binary string to a list of bytes.
  ///
  /// [binaryText] is a string representing binary data, which is divided
  /// into groups of 8 bits (1 byte) and converted into a `Uint8List`.
  static Uint8List convertBinaryToBytes(String binaryText) {
    List<int> bytes = <int>[];
    for (int i = 0; i + bitsInByte <= binaryText.length; i += bitsInByte) {
      String byteString = binaryText.substring(i, i + bitsInByte);
      int byte = int.parse(byteString, radix: 2);
      bytes.add(byte);
    }
    return Uint8List.fromList(bytes);
  }

  /// Converts the bytes to a binary string.
  static String convertBytesToBinary(Uint8List bytes) {
    return bytes.map((int byte) => byte.toRadixString(2).padLeft(BinaryUtils.bitsInByte, '0')).join();
  }
}

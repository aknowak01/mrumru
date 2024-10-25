import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

void main() {
  group('Test of BinaryUtils.convertBinaryToBytes()', () {
    test('Should [return bytes] from given binary if [binary length >= 8] and [binary length EVEN]', () {
      // Arrange
      String actualBinaryText = '0110100001100101011011000110110001101111';

      // Act
      Uint8List actualAsciiText = BinaryUtils.convertBinaryToBytes(actualBinaryText);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[104, 101, 108, 108, 111]);

      expect(actualAsciiText, expectedBytes);
    });

    test('Should [return bytes] from given binary if [binary length >= 8] and [binary length is ODD]', () {
      // Arrange
      String actualBinaryText = '000000010';

      // Act
      Uint8List actualAsciiText = BinaryUtils.convertBinaryToBytes(actualBinaryText);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[1]);

      expect(actualAsciiText, expectedBytes);
    });

    test('Should [return empty bytes] from given binary if [binary length < 8]', () {
      // Arrange
      String actualBinaryText = '000000';

      // Act
      Uint8List actualAsciiText = BinaryUtils.convertBinaryToBytes(actualBinaryText);

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[]);

      expect(actualAsciiText, expectedBytes);
    });
  });

  group('Test of BinaryUtils.convertBytesToBinary()', () {
    test('Should [return binary] from given bytes', () {
      // Arrange
      Uint8List actualData = Uint8List.fromList(<int>[1, 2, 3, 4]);

      // Act
      String actualBinaryString = BinaryUtils.convertBytesToBinary(actualData);

      // Assert
      String expectedBinaryString = '00000001000000100000001100000100';

      expect(actualBinaryString, expectedBinaryString);
    });
  });
}

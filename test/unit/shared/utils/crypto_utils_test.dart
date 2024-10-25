import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/crypto_utils.dart';

void main() {
  group('Tests of CryptoUtils.calcChecksumFromBytes()', () {
    test('Should [return checksum] for given bytes', () {
      // Arrange
      Uint8List actualBytes = base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaW1xdXl9gYWJjZGVmZ2hpamtsbW5vcHFy');

      // Act
      Uint8List actualChecksum = CryptoUtils.calcChecksum(bytes: actualBytes);

      // Assert
      Uint8List expectedChecksum = Uint8List.fromList(<int>[3, 52, 94, 221, 115, 127, 181, 28, 158, 50, 128, 132, 207, 107, 82, 43]);

      expect(actualChecksum, expectedChecksum);
    });
  });
}

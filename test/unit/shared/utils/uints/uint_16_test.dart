import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of Uint16.fromInt()', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      int actualValue = 3;

      // Act
      Uint16 actualUint16 = Uint16.fromInt(actualValue);

      // Assert
      Uint16 expectedUint16 = Uint16(Uint8List.fromList(<int>[0, 3]));

      expect(actualUint16, expectedUint16);
    });
  });

  group('Test of Uint16.fromBytes()', () {
    test('Should [return UintReminder] containing Uint16 and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 3]);

      // Act
      UintReminder<Uint16> actualUint16 = Uint16.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint16> expectedUint16 = UintReminder<Uint16>(
        Uint16(Uint8List.fromList(<int>[0, 3])),
        Uint8List.fromList(<int>[]),
      );

      expect(actualUint16, expectedUint16);
    });

    test('Should [return UintReminder] containing Uint16 and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 3, 2, 2, 3, 4, 1]);

      // Act
      UintReminder<Uint16> actualUint16 = Uint16.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint16> expectedUint16 = UintReminder<Uint16>(
        Uint16(Uint8List.fromList(<int>[0, 3])),
        Uint8List.fromList(<int>[2, 2, 3, 4, 1]),
      );

      expect(actualUint16, expectedUint16);
    });
  });

  group('Test of Uint16.bytes getter', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      Uint16 actualUint8 = Uint16.fromInt(3);

      // Act
      Uint8List actualBytes = actualUint8.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 3]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of Uint16.toInt()', () {
    test('Should [return int] from given bytes', () {
      // Arrange
      Uint16 actualUint16 = Uint16(Uint8List.fromList(<int>[0, 3]));

      // Act
      int actualValue = actualUint16.toInt();

      // Assert
      int expectedValue = 3;

      expect(actualValue, expectedValue);
    });
  });
}

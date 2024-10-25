import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of Uint32.fromInt()', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      int actualValue = 3;

      // Act
      Uint32 actualUint32 = Uint32.fromInt(actualValue);

      // Assert
      Uint32 expectedUint32 = Uint32(Uint8List.fromList(<int>[0, 0, 0, 3]));

      expect(actualUint32, expectedUint32);
    });
  });

  group('Test of Uint32.fromBytes()', () {
    test('Should [return UintReminder] containing Uint32 and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      // Act
      UintReminder<Uint32> actualUint32 = Uint32.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint32> expectedUint32 = UintReminder<Uint32>(
        Uint32(Uint8List.fromList(<int>[0, 0, 0, 3])),
        Uint8List.fromList(<int>[]),
      );

      expect(actualUint32, expectedUint32);
    });

    test('Should [return UintReminder] containing Uint32 and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3, 2, 2, 3, 4, 1]);

      // Act
      UintReminder<Uint32> actualUint32 = Uint32.fromBytes(actualBytes);

      // Assert
      UintReminder<Uint32> expectedUint32 = UintReminder<Uint32>(
        Uint32(Uint8List.fromList(<int>[0, 0, 0, 3])),
        Uint8List.fromList(<int>[2, 2, 3, 4, 1]),
      );

      expect(actualUint32, expectedUint32);
    });
  });

  group('Test of Uint32.bytes getter', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      Uint32 actualUint8 = Uint32.fromInt(3);

      // Act
      Uint8List actualBytes = actualUint8.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of Uint32.toInt()', () {
    test('Should [return int] from given bytes', () {
      // Arrange
      Uint32 actualUint32 = Uint32(Uint8List.fromList(<int>[0, 0, 0, 3]));

      // Act
      int actualValue = actualUint32.toInt();

      // Assert
      int expectedValue = 3;

      expect(actualValue, expectedValue);
    });
  });
}

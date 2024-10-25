import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of UintDynamic.fromBytes()', () {
    test('Should [return UintReminder] containing UintDynamic and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      // Act
      UintReminder<UintDynamic> actualUintDynamic = UintDynamic.fromBytes(actualBytes, 32);

      // Assert
      UintReminder<UintDynamic> expectedUintDynamic = UintReminder<UintDynamic>(
        UintDynamic(Uint8List.fromList(<int>[0, 0, 0, 3]), 32),
        Uint8List.fromList(<int>[]),
      );

      expect(actualUintDynamic, expectedUintDynamic);
    });

    test('Should [return UintReminder] containing UintDynamic and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3, 2, 2, 3, 4, 1]);

      // Act
      UintReminder<UintDynamic> actualUintDynamic = UintDynamic.fromBytes(actualBytes, 32);

      // Assert
      UintReminder<UintDynamic> expectedUintDynamic = UintReminder<UintDynamic>(
        UintDynamic(Uint8List.fromList(<int>[0, 0, 0, 3]), 32),
        Uint8List.fromList(<int>[2, 2, 3, 4, 1]),
      );

      expect(actualUintDynamic, expectedUintDynamic);
    });
  });

  group('Test of UintDynamic.bytes', () {
    test('Should [return bytes] from given value', () {
      // Arrange
      UintDynamic actualUintDynamic = UintDynamic(Uint8List.fromList(<int>[0, 0, 0, 3]), 32);

      // Act
      Uint8List actualBytes = actualUintDynamic.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      expect(actualBytes, expectedBytes);
    });
  });

  group('Test of UintDynamic.toInt()', () {
    test('Should [return int] from given bytes', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 3]);

      // Act
      int actualValue = UintDynamic(actualBytes, 32).toInt();

      // Assert
      int expectedValue = 3;

      expect(actualValue, expectedValue);
    });
  });
}

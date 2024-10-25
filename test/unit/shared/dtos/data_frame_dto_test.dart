import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/dtos/data_frame_dto.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of DataFrameDto.fromValues()', () {
    test('Should [return DataFrameDto] correctly from given values', () {
      // Act
      DataFrameDto actualDataFrameDto = DataFrameDto.fromValues(
        frameIndex: 1,
        data: Uint8List.fromList(<int>[1, 2, 3, 4]),
      );

      // Assert
      DataFrameDto expectedDataFrameDto = DataFrameDto(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 1])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 4])),
        data: UintDynamic(Uint8List.fromList(<int>[1, 2, 3, 4]), 32),
        frameChecksum: Uint16(Uint8List.fromList(<int>[70, 39])),
      );

      expect(actualDataFrameDto, expectedDataFrameDto);
    });
  });

  group('Test of DataFrameDto.fromBytes()', () {
    test('Should [return FrameReminder] containing DataFrameDto and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
      ]);

      // Act
      FrameReminder<DataFrameDto> actualDataFrameDto = DataFrameDto.fromBytes(actualBytes);

      // Assert
      FrameReminder<DataFrameDto> expectedDataFrameDto = FrameReminder<DataFrameDto>(
        value: DataFrameDto.fromValues(
          frameIndex: 1,
          data: Uint8List.fromList(<int>[1, 2, 3, 4]),
        ),
        reminder: Uint8List.fromList(<int>[]),
      );

      expect(actualDataFrameDto, expectedDataFrameDto);
    });

    test('Should [return FrameReminder] containing DataFrameDto and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
        0, 25, // reminder
      ]);

      // Act
      FrameReminder<DataFrameDto> actualDataFrameDto = DataFrameDto.fromBytes(actualBytes);

      // Assert
      FrameReminder<DataFrameDto> expectedDataFrameDto = FrameReminder<DataFrameDto>(
        value: DataFrameDto.fromValues(
          frameIndex: 1,
          data: Uint8List.fromList(<int>[1, 2, 3, 4]),
        ),
        reminder: Uint8List.fromList(<int>[0, 25]),
      );

      expect(actualDataFrameDto, expectedDataFrameDto);
    });
  });

  group('Test of DataFrameDto.toBytes()', () {
    test('Should [return bytes] representation', () {
      // Arrange
      DataFrameDto actualDataFrameDto = DataFrameDto.fromValues(frameIndex: 1, data: Uint8List.fromList(<int>[1, 2, 3, 4]));

      // Act
      Uint8List actualBytes = actualDataFrameDto.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 4, // frameLength
        1, 2, 3, 4, // data
        70, 39, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });
}

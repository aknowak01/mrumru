import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/uints/uint_16.dart';
import 'package:mrumru/src/shared/utils/uints/uint_32.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_dynamic.dart';

void main() {
  group('Test of MetadataFrameDto.fromValues()', () {
    test('Should [return MetadataFrameDto] correctly from given values', () {
      // Act
      MetadataFrameDto actualMetadataFrameDto = MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[]);

      // Assert
      MetadataFrameDto expectedMetadataFrameDto = MetadataFrameDto(
        frameIndex: Uint16(Uint8List.fromList(<int>[0, 0])),
        frameLength: Uint16(Uint8List.fromList(<int>[0, 0])),
        framesCount: Uint16(Uint8List.fromList(<int>[0, 0])),
        protocolID: ProtocolID(
          compressionMethod: Uint8.fromInt(0),
          encodingMethod: Uint8.fromInt(0),
          protocolType: Uint8.fromInt(0),
          versionNumber: Uint8.fromInt(1),
        ),
        sessionId: Uint32(Uint8List.fromList(<int>[1, 2, 3, 4])),
        compositeChecksum: Uint32(Uint8List.fromList(<int>[212, 29, 140, 217])),
        data: UintDynamic(Uint8List.fromList(<int>[]), 0),
        frameChecksum: Uint16(Uint8List.fromList(<int>[128, 97])),
      );

      expect(actualMetadataFrameDto, expectedMetadataFrameDto);
    });
  });

  group('Test of MetadataFrameDto.fromBytes()', () {
    test('Should [return FrameReminder] containing MetadataFrameDto and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // protocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        176, 125, // frameChecksum
      ]);

      // Act
      FrameReminder<MetadataFrameDto> actualMetadataFrameDto = MetadataFrameDto.fromBytes(actualBytes);

      // Assert
      FrameReminder<MetadataFrameDto> expectedMetadataFrameDto = FrameReminder<MetadataFrameDto>(
        value: MetadataFrameDto.fromValues(
          frameIndex: 1,
          protocolID: ProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[],
        ),
        reminder: Uint8List.fromList(<int>[]),
      );

      expect(actualMetadataFrameDto, expectedMetadataFrameDto);
    });

    test('Should [return FrameReminder] containing MetadataFrameDto and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[
        0, 1, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // protocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        176, 125, // frameChecksum
        0, 25, // reminder
      ]);

      // Act
      FrameReminder<MetadataFrameDto> actualMetadataFrameDto = MetadataFrameDto.fromBytes(actualBytes);

      // Assert
      FrameReminder<MetadataFrameDto> expectedMetadataFrameDto = FrameReminder<MetadataFrameDto>(
        value: MetadataFrameDto.fromValues(
          frameIndex: 1,
          protocolID: ProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[],
        ),
        reminder: Uint8List.fromList(<int>[0, 25]),
      );

      expect(actualMetadataFrameDto, expectedMetadataFrameDto);
    });
  });

  group('Test of MetadataFrameDto.toBytes()', () {
    test('Should [return bytes] representation', () {
      // Arrange
      MetadataFrameDto actualMetadataFrameDto = MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID(
            compressionMethod: Uint8.fromInt(0),
            encodingMethod: Uint8.fromInt(0),
            protocolType: Uint8.fromInt(0),
            versionNumber: Uint8.fromInt(1),
          ),
          sessionId: Uint8List.fromList(<int>[1, 2, 3, 4]),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[]);

      // Act
      Uint8List actualBytes = actualMetadataFrameDto.toBytes();

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[
        0, 0, // frameIndex
        0, 0, // frameLength
        0, 0, // framesCount
        0, 0, 0, 1, // protocolID
        1, 2, 3, 4, // sessionId
        212, 29, 140, 217, // compositeChecksum
        128, 97, // frameChecksum
      ]);

      expect(actualBytes, expectedBytes);
    });
  });
}

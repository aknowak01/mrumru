import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_id.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';
import 'package:mrumru/src/shared/utils/uints/uint_8.dart';
import 'package:mrumru/src/shared/utils/uints/uint_reminder.dart';

void main() {
  group('Test of ProtocolID.fromValues()', () {
    test('Should [return ProtocolID] created from given values', () {
      // Act
      ProtocolID actualProtocolID = ProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.raw,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      );

      // Assert
      ProtocolID expectedProtocolID = ProtocolID(
        compressionMethod: Uint8.fromInt(0),
        encodingMethod: Uint8.fromInt(0),
        protocolType: Uint8.fromInt(0),
        versionNumber: Uint8.fromInt(1),
      );

      expect(actualProtocolID, expectedProtocolID);
    });
  });

  group('Test of ProtocolID.fromBytes()', () {
    test('Should [return UintReminder] containing ProtocolID and [EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 1]);

      // Act
      UintReminder<ProtocolID> actualProtocolIDReminder = ProtocolID.fromBytes(actualBytes);

      // Assert
      UintReminder<ProtocolID> expectedProtocolIDReminder = UintReminder<ProtocolID>(
        ProtocolID.fromValues(
          compressionMethod: CompressionMethod.noCompression,
          encodingMethod: EncodingMethod.raw,
          protocolType: ProtocolType.rawDataTransfer,
          versionNumber: VersionNumber.firstDefault,
        ),
        Uint8List.fromList(<int>[]),
      );

      expect(actualProtocolIDReminder, expectedProtocolIDReminder);
    });

    test('Should [return UintReminder] containing ProtocolID and [NOT EMPTY reminder]', () {
      // Arrange
      Uint8List actualBytes = Uint8List.fromList(<int>[0, 0, 0, 1, 60, 80, 90, 100]);

      // Act
      UintReminder<ProtocolID> actualProtocolIDReminder = ProtocolID.fromBytes(actualBytes);

      // Assert
      UintReminder<ProtocolID> expectedProtocolIDReminder = UintReminder<ProtocolID>(
        ProtocolID.fromValues(
          compressionMethod: CompressionMethod.noCompression,
          encodingMethod: EncodingMethod.raw,
          protocolType: ProtocolType.rawDataTransfer,
          versionNumber: VersionNumber.firstDefault,
        ),
        Uint8List.fromList(<int>[60, 80, 90, 100]),
      );

      expect(actualProtocolIDReminder, expectedProtocolIDReminder);
    });
  });

  group('Test of ProtocolID.toBytes()', () {
    test('Should [return bytes] representing ProtocolID', () {
      // Arrange
      ProtocolID actualProtocolID = ProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.raw,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      );

      // Act
      Uint8List actualBytes = actualProtocolID.bytes;

      // Assert
      Uint8List expectedBytes = Uint8List.fromList(<int>[0, 0, 0, 1]);

      expect(actualBytes, expectedBytes);
    });
  });
}

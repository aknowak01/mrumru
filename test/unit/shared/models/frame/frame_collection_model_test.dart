import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

void main() {
  group('Tests of FrameCollectionModel.mergedBinaryFrames', () {
    test('Should [return binary string] representing merged and encoded rawData from each frame', () {
      // Arrange
      FrameCollectionModel actualFrameCollectionModel = FrameCollectionModel(<ABaseFrameDto>[
        MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID.fromValues(
            compressionMethod: CompressionMethod.noCompression,
            encodingMethod: EncodingMethod.raw,
            protocolType: ProtocolType.rawDataTransfer,
            versionNumber: VersionNumber.firstDefault,
          ),
          sessionId: base64Decode('AQIDBA=='),
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
        DataFrameDto.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),
      ]);

      // Act
      String actualString = actualFrameCollectionModel.mergedBinaryFrames;

      // Assert
      String expectedString =
          '00000000000000000000000000000000000000000000000000000000000000000000000000000001000000010000001000000011000001001101010000011101100011001101100110000'
          '00001100001000000000000000100000000001000000011000100110010001100110011010000110101001101100011011100111000001110010011101000111011001111000011110100'
          '11111000111111010000000100000101000010010000110100010001000101010001100100011101001000010010010100101001001011010011000100110101001110010011110101000'
          '01110000001110101000000000000001000000000001000000101000101010010010100110101010001010101010101100101011101011000010110010101101001011011010111010101'
          '11100101111101100000011000010110001001100011011001000110010101100110011001110110100001101001011010100110101101101100011011010110111001101111011100000'
          '11100010111111111100101000000000000001100000000000011010111001001110011011101000111010101110110011101110111100001111001011110100111101101111100011111'
          '01011111100100011011000010';

      expect(actualString, expectedString);
    });
  });

  group('Tests of FrameCollectionModel.mergedDataBytes', () {
    test('Should [return Uint8List] representing merged rawData bytes from each frame', () {
      // Arrange
      FrameCollectionModel actualFrameCollectionModel = FrameCollectionModel(<ABaseFrameDto>[
        MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID.fromValues(
            compressionMethod: CompressionMethod.noCompression,
            encodingMethod: EncodingMethod.raw,
            protocolType: ProtocolType.rawDataTransfer,
            versionNumber: VersionNumber.firstDefault,
          ),
          sessionId: base64Decode('AQIDBA=='),
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
        DataFrameDto.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),
      ]);

      // Act
      Uint8List actualBytes = actualFrameCollectionModel.mergedDataBytes;

      // Assert
      Uint8List expectedBytes = base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaW11eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX4=');

      expect(actualBytes, expectedBytes);
    });
  });
}

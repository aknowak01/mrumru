import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_encoder.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

void main() {
  group('Tests of FrameEncoder.buildFrameCollection()', () {
    test('Should [return FrameCollectionModel] from given raw data [frameDataBytesLength = 32]', () {
      // Arrange
      FrameEncoder actualFrameEncoder = FrameEncoder(frameDataBytesLength: 32);
      Uint8List actualBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameEncoder.buildFrameCollection(actualBytes);

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrameDto>[
        MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID.fromValues(
            compressionMethod: CompressionMethod.noCompression,
            encodingMethod: EncodingMethod.raw,
            protocolType: ProtocolType.rawDataTransfer,
            versionNumber: VersionNumber.firstDefault,
          ),
          sessionId: base64Decode('AQIDBA=='),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
            DataFrameDto.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),
          ],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9gYWJjZGVmZ2hpamtsbW5vcHE=')),
        DataFrameDto.fromValues(frameIndex: 3, data: base64Decode('cnN0dXZ3eHl6e3x9fg==')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from given raw data [frameDataBytesLength = 256]', () {
      // Arrange
      FrameEncoder actualFrameEncoder = FrameEncoder(frameDataBytesLength: 256);
      Uint8List actualBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameEncoder.buildFrameCollection(actualBytes);

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrameDto>[
        MetadataFrameDto.fromValues(
          frameIndex: 0,
          protocolID: ProtocolID.fromValues(
            compressionMethod: CompressionMethod.noCompression,
            encodingMethod: EncodingMethod.raw,
            protocolType: ProtocolType.rawDataTransfer,
            versionNumber: VersionNumber.firstDefault,
          ),
          sessionId: base64Decode('AQIDBA=='),
          data: Uint8List.fromList(<int>[]),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(
              frameIndex: 1,
              data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaW11eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX4='),
            ),
          ],
        ),
        DataFrameDto.fromValues(
          frameIndex: 1,
          data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaW11eX2BhYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ent8fX4='),
        ),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}

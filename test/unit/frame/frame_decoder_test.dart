import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/frame/frame_decoder.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

void main() {
  MetadataFrameDto? actualMetadataFrameDto;
  DataFrameDto? actualLastDataFrameDto;

  FrameDecoder actualFrameDecoder = FrameDecoder(
    onFirstFrameDecoded: (MetadataFrameDto metadataFrameDto) => actualMetadataFrameDto = metadataFrameDto,
    onLastFrameDecoded: (DataFrameDto dataFrameDto) => actualLastDataFrameDto = dataFrameDto,
  );

  group('Tests of FrameDecoder process', () {
    test('Should [return EMPTY FrameCollectionModel] from partially received binary data', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000000000000000000000000000000000000000000001000000000000000000000000000000001',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = const FrameCollectionModel(<ABaseFrameDto>[]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (received MetadataFrameDto)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000001000000100000001100000100010110011100011000000001111010001001111000100101',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      MetadataFrameDto expectedMetadataFrameDto = MetadataFrameDto.fromValues(
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
          DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
        ],
      );

      FrameCollectionModel expectedFrameCollectionModel = FrameCollectionModel(<ABaseFrameDto>[expectedMetadataFrameDto]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
      expect(actualMetadataFrameDto, expectedMetadataFrameDto);
    });

    test('Should [return FrameCollectionModel] from partially received binary data (contains MetadataFrameDto)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '00000000000000010000000000100000001100010011001000110011001101000011010100110110001101110011100000111001001110100011101100111100001111010011111000111111',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

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
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (contains MetadataFrameDto and DataFrameDto)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '01000000010000010100001001000011010001000100010101000110010001110100100001001001010010100100101101001100010011010100111001001111010100001110000001110101',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

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
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from partially received binary data (contains MetadataFrameDto and DataFrameDto)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '000000000000001000000000000011110101000101010010010100110101010001010101010101100101',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

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
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g')),
          ],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });

    test('Should [return FrameCollectionModel] from fully received binary data (contains MetadataFrameDto, DataFrameDto and last DataFrameDto)', () {
      // Arrange
      actualFrameDecoder.addBinaries(<String>[
        '011101011000010110010101101001011011010111010101111001011111011000001111110100101100',
      ]);

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      DataFrameDto expectedLastDataFrameDto = DataFrameDto.fromValues(frameIndex: 2, data: base64Decode('UVJTVFVWV1hZWltdXl9g'));
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
          data: Uint8List(0),
          dataFramesDtos: <DataFrameDto>[
            DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
            expectedLastDataFrameDto,
          ],
        ),
        DataFrameDto.fromValues(frameIndex: 1, data: base64Decode('MTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1A=')),
        expectedLastDataFrameDto,
      ]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
      expect(actualLastDataFrameDto, expectedLastDataFrameDto);
    });

    test('Should [return EMPTY FrameCollectionModel] after data cleared', () {
      // Arrange
      actualFrameDecoder.clear();

      // Act
      FrameCollectionModel actualFrameCollectionModel = actualFrameDecoder.decodedContent;

      // Assert
      FrameCollectionModel expectedFrameCollectionModel = const FrameCollectionModel(<ABaseFrameDto>[]);

      expect(actualFrameCollectionModel, expectedFrameCollectionModel);
    });
  });
}

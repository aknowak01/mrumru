import 'dart:math';
import 'dart:typed_data';

import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';

/// A class responsible for encoding bytes into frames.
class FrameEncoder {
  /// The maximum number of bytes allowed in each frame's data section.
  final int frameDataBytesLength;

  /// Creates a new [FrameEncoder] with a specific frame data length.
  FrameEncoder({required this.frameDataBytesLength});

  /// Builds a frame collection from bytes.
  FrameCollectionModel buildFrameCollection(Uint8List dataBytes) {
    List<DataFrameDto> dataFramesDtos = <DataFrameDto>[];
    int dataFramesCount = (dataBytes.length / frameDataBytesLength).ceil();

    for (int i = 0; i < dataFramesCount; i++) {
      Uint8List data = _splitDataForIndex(dataBytes, i);
      int frameIndex = i + 1;

      dataFramesDtos.add(DataFrameDto.fromValues(
        frameIndex: frameIndex,
        data: data,
      ));
    }

    MetadataFrameDto metadataFrameDto = MetadataFrameDto.fromValues(
      frameIndex: 0,
      protocolID: ProtocolID.fromValues(
        compressionMethod: CompressionMethod.noCompression,
        encodingMethod: EncodingMethod.raw,
        protocolType: ProtocolType.rawDataTransfer,
        versionNumber: VersionNumber.firstDefault,
      ),
      sessionId: _generateSessionId(),
      data: Uint8List(0),
      dataFramesDtos: dataFramesDtos,
    );

    return FrameCollectionModel(<ABaseFrameDto>[metadataFrameDto, ...dataFramesDtos]);
  }

  /// Splits bytes into chunks for each frame.
  Uint8List _splitDataForIndex(Uint8List dataBytes, int index) {
    int startIndex = index * frameDataBytesLength;
    int endIndex = min(startIndex + frameDataBytesLength, dataBytes.length);
    return dataBytes.sublist(startIndex, endIndex);
  }

  /// Generates a session ID for the frame collection.
  Uint8List _generateSessionId() {
    return Uint8List.fromList(<int>[1, 2, 3, 4]);
  }
}

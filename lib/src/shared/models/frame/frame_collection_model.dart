import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:mrumru/src/shared/dtos/a_base_frame_dto.dart';
import 'package:mrumru/src/shared/dtos/data_frame_dto.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';

/// A class representing a collection of frames.
class FrameCollectionModel extends Equatable {
  /// The list of frames in this collection.
  final List<ABaseFrameDto> frames;

  /// Creates an instance of [FrameCollectionModel] with the provided [frames].
  const FrameCollectionModel(this.frames);

  /// Merges the binary representations of all frames into a single binary string.
  String get mergedBinaryFrames {
    return frames.map((ABaseFrameDto baseFrameDto) => BinaryUtils.convertBytesToBinary(baseFrameDto.toBytes())).join();
  }

  /// Merges the data bytes of all data frames into a single byte array.
  Uint8List get mergedDataBytes {
    return Uint8List.fromList(
      frames.whereType<DataFrameDto>().map((DataFrameDto baseFrameDto) => baseFrameDto.data.bytes).expand((Uint8List bytes) => bytes).toList(),
    );
  }

  @override
  List<Object?> get props => <Object>[frames];
}

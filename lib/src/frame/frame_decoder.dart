import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/shared/exceptions/bytes_too_short_exception.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:mrumru/src/shared/utils/binary_utils.dart';
import 'package:mrumru/src/shared/utils/frame_reminder.dart';
import 'package:mrumru/src/shared/utils/log_level.dart';

/// A class that decodes binary data into frames.
class FrameDecoder {
  /// Called whenever any frame is successfully decoded.
  final ValueChanged<ABaseFrameDto>? onFrameDecoded;

  /// Called when the first (metadata) frame is decoded.
  final ValueChanged<MetadataFrameDto>? onFirstFrameDecoded;

  /// Called when the last frame is decoded.
  final ValueChanged<DataFrameDto>? onLastFrameDecoded;

  /// A list of all successfully decoded frames.
  final List<ABaseFrameDto> _decodedFrames = <ABaseFrameDto>[];

  /// The complete binary data as a string in StringBuffer.
  final StringBuffer _completeBinary = StringBuffer();

  /// Thi cursor points current position of the decoder within the binary data.
  int _cursor = 0;

  /// The metadata frame that has been decoded used to guide the decoding process.
  MetadataFrameDto? _metadataFrameDto;

  /// Creates a [FrameDecoder] with optional callbacks for frame decoding events.
  FrameDecoder({
    this.onFrameDecoded,
    this.onFirstFrameDecoded,
    this.onLastFrameDecoded,
  });

  /// This method takes a list of binary strings, appends them to the existing
  /// binary data buffer, and then attempts to decode frames.
  void addBinaries(List<String> binaries) {
    for (String binary in binaries) {
      _completeBinary.write(binary);
    }
    _decodeFrames();
  }

  /// Returns the decoded frames as a [FrameCollectionModel].
  FrameCollectionModel get decodedContent {
    return FrameCollectionModel(List<ABaseFrameDto>.from(_decodedFrames));
  }

  /// This method clears both the decoded frames and the binary data buffer,
  /// resetting the cursor and metadata frame to their initial state.
  void clear() {
    _decodedFrames.clear();
    _completeBinary.clear();
    _cursor = 0;
    _metadataFrameDto = null;
  }

  /// Depending on the current state, this either decodes the metadata frame or
  /// the subsequent data frames.
  void _decodeFrames() {
    if (_isMetadataFrameDtoDecoded == false) {
      _decodeMetadataFrameDto();
    } else {
      _decodeDataFrameDto();
    }
  }

  /// Returns `true` if the metadata frame is already decoded, otherwise `false`.
  bool get _isMetadataFrameDtoDecoded => _metadataFrameDto != null;

  /// Decodes metadata frame, which is crucial for guiding the decoding of subsequent frames.
  /// If the data is incomplete, decoding is deferred until more data is added.
  void _decodeMetadataFrameDto() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_nextBinaryData);

    try {
      FrameReminder<MetadataFrameDto> decodedMetadataFrameDto = MetadataFrameDto.fromBytes(bytes);
      MetadataFrameDto metadataFrameDto = decodedMetadataFrameDto.value;

      _metadataFrameDto = metadataFrameDto;
      _decodedFrames.add(metadataFrameDto);
      _cursor += decodedMetadataFrameDto.bitsConsumed;

      onFirstFrameDecoded?.call(metadataFrameDto);
      onFrameDecoded?.call(metadataFrameDto);

      _decodeFrames();
    } on BytesTooShortException catch (_) {
      return;
    } catch (e) {
      AppLogger().log(message: 'Error while decoding metadata frame: $e', logLevel: LogLevel.error);
      rethrow;
    }
  }

  /// Each data frame is decoded in sequence after the metadata frame. The process
  /// continues until all frames have been decoded or more data is needed.
  void _decodeDataFrameDto() {
    Uint8List bytes = BinaryUtils.convertBinaryToBytes(_nextBinaryData);

    try {
      FrameReminder<DataFrameDto> decodedDataFrameDto = DataFrameDto.fromBytes(bytes);
      DataFrameDto dataFrameDto = decodedDataFrameDto.value;

      _decodedFrames.add(dataFrameDto);
      _cursor += decodedDataFrameDto.bitsConsumed;

      bool lastFrameBool = _metadataFrameDto!.framesCount.toInt() == dataFrameDto.frameIndex.toInt();
      if (lastFrameBool) {
        onFrameDecoded?.call(dataFrameDto);
        onLastFrameDecoded?.call(dataFrameDto);
      } else {
        onFrameDecoded?.call(dataFrameDto);
        _decodeFrames();
      }
    } on BytesTooShortException catch (_) {
      return;
    } catch (e) {
      AppLogger().log(message: 'Error while decoding data frame: $e', logLevel: LogLevel.error);
      rethrow;
    }
  }

  /// This getter returns the remaining binary data that has not yet been decoded.
  String get _nextBinaryData => _completeBinary.toString().substring(_cursor);
}

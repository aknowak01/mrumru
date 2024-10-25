import 'dart:typed_data';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/generator/sample_generator.dart';
import 'package:mrumru/src/audio/generator/samples_processor.dart';
import 'package:mrumru/src/frame/frame_encoder.dart';
import 'package:mrumru/src/shared/models/sample_model.dart';

/// A class that generates audio signals from text messages using Frequency Shift Keying (FSK).
class AudioGenerator {
  /// The sink where the generated audio will be outputted.
  final IAudioSink _audioSink;

  /// The settings model for audio configuration.
  final AudioSettingsModel _audioSettingsModel;

  /// Optional notifier for audio generation events.
  final AudioGeneratorNotifier? _audioGeneratorNotifier;

  /// The sample processor to process the samples list into wave.
  final SamplesProcessor _samplesProcessor;

  /// The sample generator to build samples from binary data.
  final SampleGenerator _sampleGenerator;

  /// Creates an instance of [AudioGenerator].
  AudioGenerator({
    required IAudioSink audioSink,
    required AudioSettingsModel audioSettingsModel,
    AudioGeneratorNotifier? audioGeneratorNotifier,
  })  : _audioGeneratorNotifier = audioGeneratorNotifier,
        _audioSettingsModel = audioSettingsModel,
        _audioSink = audioSink,
        _samplesProcessor = SamplesProcessor(),
        _sampleGenerator = SampleGenerator(audioSettingsModel);

  /// This method encodes the bytes into binary, converts the binary data
  /// into frequencies using FSK, and then builds and pushes audio samples to the sink.
  Future<void> generate(Uint8List bytes) async {
    String binaryData = _parseBytesToBinary(bytes);
    _audioGeneratorNotifier?.onBinaryCreated?.call(binaryData);

    List<SampleModel> samplesList = _sampleGenerator.buildSamplesFromBinary(binaryData);
    _audioGeneratorNotifier?.onFrequenciesCreated?.call(samplesList);

    Duration transferDuration = Duration(milliseconds: ((samplesList.length + 2) * _audioSettingsModel.sampleDuration.inMilliseconds).toInt());
    await _audioSink.init(transferDuration, _audioSettingsModel.sampleRate);
    _startBuildingSamples(samplesList);
  }

  /// Stops the audio generation process and kills the audio sink.
  Future<void> stop() async {
    await _audioSink.kill();
    _samplesProcessor.close();
  }

  /// This method parses the bytes into binary data.
  String _parseBytesToBinary(Uint8List bytes) {
    FrameEncoder frameEncoder = FrameEncoder(frameDataBytesLength: _audioSettingsModel.frameDataBytesLength);
    FrameCollectionModel frameCollectionModel = frameEncoder.buildFrameCollection(bytes);
    String binaryData = frameCollectionModel.mergedBinaryFrames;
    return _fillBinaryWithZeros(binaryData);
  }

  /// This method fills the binary data with zeros to make it divisible by the required number of bits.
  String _fillBinaryWithZeros(String binaryData) {
    int divider = _audioSettingsModel.bitsPerFrequency * _audioSettingsModel.chunksCount;
    int remainder = binaryData.length % divider;
    int zerosToAdd = remainder == 0 ? 0 : divider - remainder;
    return binaryData + List<String>.filled(zerosToAdd, '0').join('');
  }

  /// This method uses a [SamplesProcessor] to process the samples into wave
  /// and pushes each sample to the audio sink.
  void _startBuildingSamples(List<SampleModel> samplesList) {
    _samplesProcessor
        .processSamples(
            samplesList: samplesList,
            onSampleCreated: (Float32List sample) {
              _audioSink.pushSample(sample);
              _audioGeneratorNotifier?.onSampleCreated?.call(sample);
            })
        .then((_) => _audioSink.notifyAllSamplesCreated());
  }
}

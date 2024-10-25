library mrumru;

/// A library for transmitting data using sound waves.

/// Generates audio samples from text messages.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioGenerator].
///   AudioGenerator audioGenerator = AudioGenerator(
///     audioSink: AudioSink(),
///     audioSettingsModel: AudioSettingsModel(),
///     audioGeneratorNotifier: AudioGeneratorNotifier(),
///   );
///
///   // Generates audio samples from the provided [textMessage] and adds them to the given [AudioSink]
///   audioGenerator.generate(textMessage);
///   ```
export 'package:mrumru/src/audio/generator/audio_generator.dart';
export 'package:mrumru/src/audio/generator/audio_generator_notifier.dart';

/// Sinks provides more organized way of providing or saving samples. It can be used to pass audio samples as multiple data types, such as streams, files, etc
///
/// Usage:
///   ```
///   // Audio multi sink used to pass audio samples to multiple sinks.
///   AudioMultiSink audioMultiSink = AudioMultiSink(<IAudioSink>[audioFileSink, audioStreamSink]);
///
///   // Audio file sink used to save audio samples to a file.
///   AudioFileSink audioFileSink = AudioFileSink(file);
///
///   // Audio stream sink used to pass audio samples to a stream.
///   AudioStreamSink audioStreamSink = AudioStreamSink();
///
///  ```
export 'package:mrumru/src/audio/generator/sink/audio_file_sink.dart';
export 'package:mrumru/src/audio/generator/sink/audio_multi_sink.dart';
export 'package:mrumru/src/audio/generator/sink/audio_stream_sink.dart';
export 'package:mrumru/src/audio/generator/sink/i_audio_sink.dart';

/// Records audio samples from the microphone.
///
/// Usage:
///   ```
///   // Creates an instance of [AudioRecorderController].
///   AudioRecorderController audioRecorderController = AudioRecorderController(
///     audioSettingsModel: AudioSettingsModel(),
///     onRecordingCompleted: () {},
///     onFrameReceived: (FrameModel frameModel) {},
///   );
///
///   // Starts recording audio samples.
///   audioRecorderController.startRecording();
///
///   // Stops recording audio samples.
///   audioRecorderController.stopRecording();
///  ```
export 'package:mrumru/src/audio/recorder/audio_recorder_controller.dart';
export 'package:mrumru/src/shared/dtos/a_base_frame_dto.dart';
export 'package:mrumru/src/shared/dtos/data_frame_dto.dart';
export 'package:mrumru/src/shared/dtos/metadata_frame_dto.dart';
export 'package:mrumru/src/shared/dtos/protocol_id.dart';

/// Adds audio settings that can be modified to customize the audio structure.
///
/// Usage:
///  ```
///   // Creates an instance of [AudioSettingsModel].
///   AudioSettingsModel audioSettingsModel = AudioSettingsModel(
///     sampleRate: 44100,
///     channels: 1,
///     baseFrequency: 1000,
///     bitDepth: 16,
///     bitsPerFrequency: 4,
///     chunksCount: 4,
///   );
///
///
///   // Creates an instance of [AudioSettingsModel] with default values.
///   AudioSettingsModel audioSettingsModel = AudioSettingsModel.withDefaults();
///
///   // Modifies the values of [AudioSettingsModel] for example [sampleRate].
///   audioSettingsModel = audioSettingsModel.copyWith(sampleRate: 48000);
///
///   // Get [maxFrequency] value from [AudioSettingsModel] calculated from the provided values.
///   int maxFrequency = audioSettingsModel.maxFrequency;
///
///   // Get [possibleFrequencies] from [AudioSettingsModel] calculated from the provided values.
///   List<int> possibleFrequencies = audioSettingsModel.possibleFrequencies;
///
///   ```
export 'package:mrumru/src/shared/models/audio_settings_model.dart';

/// A class representing a collection of frames.
///
/// Usage:
///   ```dart
///   // Creating an instance of [FrameCollectionModel].
///   FrameCollectionModel frameCollection = FrameCollectionModel([
///     metadataFrame,
///     dataFrame1,
///     dataFrame2,
///   ]);
///
///
///   // Accessing merged binary frames from the collection.
///   String mergedFrames = frameCollection.mergedBinaryFrames;
///
///   // Accessing merged data bytes from the collection.
///   Uint8List mergedData = frameCollection.mergedDataBytes;
///   ```
export 'package:mrumru/src/shared/models/frame/frame_collection_model.dart';

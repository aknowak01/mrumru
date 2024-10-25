import 'dart:math';

import 'package:equatable/equatable.dart';

/// A model representing the settings for audio configuration.
class AudioSettingsModel with EquatableMixin {
  /// Static value for fade calculation
  static const double millisecondsInSeconds = 1000.0;

  /// Static value for samples calculation. Provides number of samples.
  static const int defaultSampleRate = 44000;

  /// Static value that provides the scale factor for the number of samples in WAV.
  static const double sampleScaleFactor = 2.5;

  /// The set of audio settings parameters.
  final int firstFrequency;
  final int bitsPerFrequency;
  final int channels;
  final int chunksCount;
  final int baseFrequencyGap;
  final int frameDataBytesLength;
  final int maxSkippedSamples;
  final double frequencyFactor;
  final Duration fadeDuration;
  final Duration sampleDuration;
  final List<int> startFrequencies;
  final List<int> endFrequencies;

  late final int maxStartOffset;
  late final int sampleRate;
  late final int sampleSize;
  late final int maxBaseFrequency;
  late final int frequenciesCountPerChunk;
  late final double amplitude;
  late final List<int> allPossibleFrequencies;
  late final List<int> allPossibleFrequenciesWithAdjustedGap;
  late final List<int> possibleBaseFrequencies;
  late final List<List<int>> possibleDynamicFrequenciesForChunks;

  /// Creates an instance of [AudioSettingsModel].
  AudioSettingsModel({
    required this.firstFrequency,
    required this.bitsPerFrequency,
    required this.channels,
    required this.chunksCount,
    required this.baseFrequencyGap,
    required this.frameDataBytesLength,
    required this.maxSkippedSamples,
    required this.frequencyFactor,
    required this.fadeDuration,
    required this.sampleDuration,
    required this.startFrequencies,
    required this.endFrequencies,
    int? sampleRate,
  }) {
    amplitude = 1 / chunksCount;
    frequenciesCountPerChunk = pow(2, bitsPerFrequency).toInt();
    allPossibleFrequencies = _generatePossibleFrequencies();
    allPossibleFrequenciesWithAdjustedGap = _getPossibleFrequenciesWithAdjustedGap();
    possibleBaseFrequencies = _calcPossibleBaseFrequencies();
    maxBaseFrequency = _calcMaxBaseFrequency();
    possibleDynamicFrequenciesForChunks = _calcPossibleDynamicFrequenciesForChunks();
    this.sampleRate = sampleRate ?? max(defaultSampleRate, sampleScaleFactor * chunksCount * maxBaseFrequency).toInt();
    sampleSize = this.sampleRate * sampleDuration.inMilliseconds ~/ millisecondsInSeconds;
    maxStartOffset = (maxSkippedSamples * sampleSize).toInt();
  }

  /// Creates an instance of [AudioSettingsModel] with default settings.
  factory AudioSettingsModel.withDefaults() {
    return AudioSettingsModel(
      firstFrequency: 400,
      bitsPerFrequency: 2,
      channels: 1,
      chunksCount: 64,
      baseFrequencyGap: 50,
      frameDataBytesLength: 32,
      maxSkippedSamples: 7,
      frequencyFactor: 1 / 340,
      fadeDuration: const Duration(milliseconds: 100),
      sampleDuration: const Duration(milliseconds: 200),
      startFrequencies: <int>[500, 700],
      endFrequencies: <int>[900, 1100],
    );
  }

  /// Creates a copy of this [AudioSettingsModel] with the given parameters.
  /// Any parameter that is not provided will use the value from the current instance.
  AudioSettingsModel copyWith({
    int? firstFrequency,
    int? bitsPerFrequency,
    int? channels,
    int? chunksCount,
    int? baseFrequencyGap,
    int? frameDataBytesLength,
    int? maxSkippedSamples,
    double? frequencyFactor,
    Duration? fadeDuration,
    Duration? sampleDuration,
    List<int>? startFrequencies,
    List<int>? endFrequencies,
    int? sampleRate,
  }) {
    return AudioSettingsModel(
      firstFrequency: firstFrequency ?? this.firstFrequency,
      bitsPerFrequency: bitsPerFrequency ?? this.bitsPerFrequency,
      channels: channels ?? this.channels,
      chunksCount: chunksCount ?? this.chunksCount,
      baseFrequencyGap: baseFrequencyGap ?? this.baseFrequencyGap,
      frameDataBytesLength: frameDataBytesLength ?? this.frameDataBytesLength,
      maxSkippedSamples: maxSkippedSamples ?? this.maxSkippedSamples,
      frequencyFactor: frequencyFactor ?? this.frequencyFactor,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      sampleDuration: sampleDuration ?? this.sampleDuration,
      startFrequencies: startFrequencies ?? this.startFrequencies,
      endFrequencies: endFrequencies ?? this.endFrequencies,
      sampleRate: sampleRate ?? this.sampleRate,
    );
  }

  /// Assigns dynamic gap for the given frequencies.
  List<int> assignDynamicGap(List<int> frequencies) {
    List<int> frequenciesWithAdjustedGap = <int>[];
    for (int frequency in frequencies) {
      int index = allPossibleFrequencies.indexOf(frequency);
      int adjustedFrequency = allPossibleFrequenciesWithAdjustedGap[index];
      frequenciesWithAdjustedGap.add(adjustedFrequency);
    }

    return frequenciesWithAdjustedGap;
  }

  /// Removes dynamic gap for the given frequency.
  int removeDynamicGap(int frequency) {
    int index = allPossibleFrequenciesWithAdjustedGap.indexOf(frequency);
    int adjustedFrequency = allPossibleFrequencies[index];
    return adjustedFrequency;
  }

  /// Parses base frequencies to chunk frequencies for the given frequency and chunk index.
  int parseBaseFrequencyToChunkFrequency(int frequency, int chunkIndex) {
    int alignedFrequency = frequency - firstFrequency;
    int alignedMaxBaseFrequency = maxBaseFrequency - firstFrequency;

    int chunkShift = chunkIndex * alignedMaxBaseFrequency;
    int chunkedFrequency = alignedFrequency + chunkShift + firstFrequency + (chunkIndex * baseFrequencyGap);

    return chunkedFrequency;
  }

  /// Parses chunk frequencies to base frequencies for the given frequency and chunk index.
  int parseChunkFrequencyToFrequency(int chunkFrequency, int chunkIndex) {
    int alignedMaxBaseFrequency = maxBaseFrequency - firstFrequency;

    int chunkShift = chunkIndex * alignedMaxBaseFrequency;
    int alignedChunkFrequency = chunkFrequency - chunkShift - firstFrequency - (chunkIndex * baseFrequencyGap);

    int originalFrequency = alignedChunkFrequency + firstFrequency;

    return originalFrequency;
  }

  /// Gets list of possible frequencies for the given chunk.
  List<int> getPossibleFrequenciesForChunk(int chunkIndex) {
    return possibleDynamicFrequenciesForChunks[chunkIndex];
  }

  /// Generates possible frequencies based on the first frequency and base frequency gap.
  List<int> _generatePossibleFrequencies() {
    int possibleFrequenciesCount = frequenciesCountPerChunk * chunksCount;
    List<int> possibleFrequencies = List<int>.generate(possibleFrequenciesCount, (int i) => firstFrequency + i * baseFrequencyGap);

    return possibleFrequencies;
  }

  /// Gets possible frequencies with adjusted gap from the possible frequencies.
  List<int> _getPossibleFrequenciesWithAdjustedGap() {
    List<int> adjustedFrequencies = <int>[firstFrequency];

    for (int i = 1; i < allPossibleFrequencies.length; i++) {
      int frequency = allPossibleFrequencies[i];
      int gap = (frequency * frequencyFactor).round();

      int adjustedFrequency = frequency + gap;
      adjustedFrequencies.add(adjustedFrequency);
    }

    return adjustedFrequencies;
  }

  /// Calculate possible base frequencies.
  List<int> _calcPossibleBaseFrequencies() {
    List<int> possibleFrequencies = List<int>.generate(frequenciesCountPerChunk, (int i) => firstFrequency + (i * baseFrequencyGap));

    return possibleFrequencies;
  }

  /// Gets the maximum frequency based on the base frequency and frequency gap.
  int _calcMaxBaseFrequency() {
    return possibleBaseFrequencies.last;
  }

  /// Calculates the possible frequencies for each chunk.
  List<List<int>> _calcPossibleDynamicFrequenciesForChunks() {
    List<List<int>> possibleFrequenciesForChunks = <List<int>>[];
    for (int i = 0; i < chunksCount; i++) {
      List<int> possibleFrequenciesForChunk = _calcPossibleFrequenciesForChunk(i);
      possibleFrequenciesForChunks.add(possibleFrequenciesForChunk);
    }
    return possibleFrequenciesForChunks;
  }

  /// Calculates the possible frequencies for the given chunk.
  List<int> _calcPossibleFrequenciesForChunk(int chunkIndex) {
    int chunkStart = frequenciesCountPerChunk * chunkIndex;
    int chunkEnd = chunkStart + frequenciesCountPerChunk;

    return allPossibleFrequenciesWithAdjustedGap.sublist(chunkStart, chunkEnd);
  }

  @override
  List<Object> get props => <Object>[
        firstFrequency,
        bitsPerFrequency,
        channels,
        chunksCount,
        baseFrequencyGap,
        frequencyFactor,
        fadeDuration,
        sampleDuration,
        startFrequencies,
        endFrequencies,
      ];
}

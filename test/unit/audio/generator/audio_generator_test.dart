import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:wav/wav.dart';

import '../../../utils/test_utils.dart';

void main() async {
  Uint8List actualBytes = utf8.encode('12345678');
  File actualWavTestFile = File('${Directory.systemTemp.path}/test.wav');

  group('Test of AudioGenerator.generate()', () {
    test('Should [generate wave] from given message [chunksCount == 1]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 1),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_1.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 2]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 2),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_2.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 4]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 4),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_4.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 8]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 8),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_8.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 16]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 16),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_16.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 32]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 32),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_32.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });

    test('Should [generate wave] from given message [chunksCount == 64]', () async {
      // Arrange
      AudioFileSink audioFileSink = AudioFileSink(actualWavTestFile);

      // Act
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: AudioSettingsModel.withDefaults().copyWith(chunksCount: 64),
        audioGeneratorNotifier: AudioGeneratorNotifier(),
      ).generate(actualBytes);
      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavTestFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Assert
      List<double> expectedWave = await TestUtils.readAsDoubleFromFile(File('test/unit/audio/assets/mocked_audio_wave_chunks_count_64.txt'));

      // Values are rounded to 10 decimal places to avoid operating system differences in the generated calculated values
      expect(TestUtils.roundList(actualWave, 10), TestUtils.roundList(expectedWave, 10));
    });
  });
}

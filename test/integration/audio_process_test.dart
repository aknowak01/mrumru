import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/shared/dtos/compression_method.dart';
import 'package:mrumru/src/shared/dtos/encoding_method.dart';
import 'package:mrumru/src/shared/dtos/protocol_type.dart';
import 'package:mrumru/src/shared/enums/version_number.dart';
import 'package:mrumru/src/shared/utils/app_logger.dart';
import 'package:wav/wav.dart';

void main() async {
  group('Tests of AudioGenerator.generate() and PacketRecognizer.decodedContent()', () {
    test('Should generate and correctly decode .WAV file', () async {
      // Arrange
      AudioSettingsModel actualAudioSettingsModel = AudioSettingsModel.withDefaults().copyWith(chunksCount: 16, maxSkippedSamples: 1);
      File actualWavFile = File('./test/integration/assets/mocked_wave_file.wav');
      Uint8List actualInputBytes = utf8.encode('123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz{|}~');
      AudioFileSink audioFileSink = AudioFileSink(actualWavFile);
      late FrameCollectionModel actualFrameCollectionModel;

      PacketRecognizer actualPacketRecognizer = PacketRecognizer(
        audioSettingsModel: actualAudioSettingsModel,
        onDecodingCompleted: (FrameCollectionModel frameCollectionModel) => actualFrameCollectionModel = frameCollectionModel,
        onFrameDecoded: (ABaseFrameDto baseFrameDto) {
          AppLogger().log(message: 'Frame decoded: $baseFrameDto');
        },
      );

      // Act (AudioGenerator)
      await AudioGenerator(
        audioSink: audioFileSink,
        audioSettingsModel: actualAudioSettingsModel,
      ).generate(actualInputBytes);

      await audioFileSink.future;
      Uint8List actualWavFileBytes = await actualWavFile.readAsBytes();
      List<double> actualWave = Wav.read(actualWavFileBytes).channels.first;

      // Act (PacketRecognizer)
      List<PacketReceivedEvent> testEvents = _prepareTestEvents(actualAudioSettingsModel.sampleSize, actualWave);

      unawaited(actualPacketRecognizer.startDecoding());

      for (PacketReceivedEvent packetReceivedEvent in testEvents) {
        actualPacketRecognizer.addPacket(packetReceivedEvent);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

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
  });
}

List<PacketReceivedEvent> _prepareTestEvents(int sampleSize, List<double> wave) {
  List<List<double>> samples = <List<double>>[];
  for (int i = 0; i < wave.length; i += sampleSize) {
    samples.add(wave.sublist(i, min(i + sampleSize, wave.length)));
  }
  List<PacketReceivedEvent> packetReceivedEvent = samples.map(PacketReceivedEvent.new).toList();
  return packetReceivedEvent;
}

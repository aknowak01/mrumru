import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mrumru/mrumru.dart';
import 'package:mrumru/src/audio/recorder/packet_recognizer.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/shared/utils/wav_utils.dart';
import 'package:record/record.dart';
import 'package:wav/wav.dart';

class AudioRecorderController {
  final AudioRecorder audioRecorder = AudioRecorder();
  final ValueChanged<ABaseFrameDto>? onFrameReceived;
  final ValueChanged<FrameCollectionModel> onRecordingCompleted;
  final AudioSettingsModel audioSettingsModel;
  late final PacketRecognizer packetRecognizer;
  StreamSubscription<Uint8List>? recordingStreamSubscription;

  AudioRecorderController({
    required this.audioSettingsModel,
    required this.onRecordingCompleted,
    required this.onFrameReceived,
  });

  Future<void> startRecording() async {
    RecordConfig recordConfig = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: audioSettingsModel.sampleRate,
      numChannels: audioSettingsModel.channels,
    );
    Stream<Uint8List> recordingStream = await audioRecorder.startStream(recordConfig);

    packetRecognizer = PacketRecognizer(
      audioSettingsModel: audioSettingsModel,
      onFrameDecoded: onFrameReceived,
      onDecodingCompleted: _completeDecoding,
    );

    unawaited(packetRecognizer.startDecoding());

    recordingStreamSubscription = recordingStream.listen(_addEvent);
  }

  void stopRecording() {
    packetRecognizer.stopRecording();
  }

  Future<void> _completeDecoding(FrameCollectionModel frameCollectionModel) async {
    if (await audioRecorder.isRecording()) {
      await audioRecorder.stop();
      await recordingStreamSubscription?.cancel();
      onRecordingCompleted(frameCollectionModel);
    }
  }

  void _addEvent(Uint8List packet) {
    Wav customWave = WavUtils.readPCM16Bytes(packet, audioSettingsModel);
    packetRecognizer.addPacket(PacketReceivedEvent(customWave.channels.first));
  }
}

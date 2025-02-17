import 'package:mrumru/src/audio/recorder/queue/events/a_packet_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_received_event.dart';
import 'package:mrumru/src/audio/recorder/queue/events/packet_remaining_event.dart';

class PacketEventQueue {
  List<APacketEvent> eventQueue = <APacketEvent>[];

  PacketEventQueue({List<APacketEvent>? queue}) : eventQueue = queue ?? <APacketEvent>[];

  bool isLongerThan(int waveSize) {
    int totalLength = 0;
    for (APacketEvent packet in eventQueue) {
      totalLength += packet.length;
      if (totalLength >= waveSize) {
        return true;
      }
    }
    return false;
  }

  Future<List<double>> readWave(int waveSize) async {
    List<double> wave = <double>[];
    while (wave.length < waveSize) {
      APacketEvent packetEvent = pop();
      wave.addAll(packetEvent.packet);
    }
    List<double> data = wave.sublist(0, waveSize);
    List<double> remainingData = wave.sublist(waveSize);
    if (remainingData.isNotEmpty) {
      push(PacketRemainingEvent(remainingData));
    }
    return data;
  }

  APacketEvent pop() {
    if (eventQueue.isNotEmpty) {
      return eventQueue.removeAt(0);
    } else {
      throw Exception('Cannot read sample queue is empty');
    }
  }

  void push(APacketEvent packetEvent) {
    if (packetEvent is PacketReceivedEvent) {
      eventQueue.add(packetEvent);
    } else if (packetEvent is PacketRemainingEvent) {
      eventQueue.insert(0, packetEvent);
    }
  }

  void clear() {
    eventQueue.clear();
  }
}

import 'package:example/cubit/receive_tab_cubit/a_receive_tab_state.dart';
import 'package:example/cubit/receive_tab_cubit/receive_tab_cubit.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_recording_state.dart';
import 'package:example/cubit/receive_tab_cubit/states/receive_tab_result_state.dart';
import 'package:example/widgets/settings_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReceiveTab extends StatefulWidget {
  final ReceiveTabCubit receiveTabCubit;

  const ReceiveTab({required this.receiveTabCubit, super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveTabState();
}

class _ReceiveTabState extends State<ReceiveTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<ReceiveTabCubit, AReceiveTabState>(
        bloc: widget.receiveTabCubit,
        builder: (BuildContext context, AReceiveTabState state) {
          bool recordingInProgressBool = state is ReceiveTabRecordingState;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? null : widget.receiveTabCubit.startRecording,
                        child: const Text('Start recording'),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: recordingInProgressBool ? widget.receiveTabCubit.stopRecording : null,
                        child: const Text('Stop recording'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (state is ReceiveTabResultState)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(state.decodedMessage),
                  ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SettingsPreview(audioSettingsModel: widget.receiveTabCubit.audioSettingsModel),
                ),
                const SizedBox(height: 40),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ValueListenableBuilder<String>(
                    valueListenable: widget.receiveTabCubit.consoleNotifier,
                    builder: (BuildContext context, String logs, _) {
                      return Text(logs, style: const TextStyle(fontSize: 11));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

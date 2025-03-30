import 'package:flutter/material.dart';
import '../widgets/recording_indicator.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  bool _isRecording = false;

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });

    // TODO: Start your actual recording logic here
    print('Recording started');
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });

    // TODO: Stop your actual recording logic here
    print('Recording stopped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Color(0xFFEDEBFA), // light gray,
      appBar: AppBar(title: const Text('RecallIT AI')),
      body: Center(
        child: _isRecording
            ? RecordingIndicator(onStop: _stopRecording)
            : ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0xFF6750A4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                onPressed: _startRecording,
                icon: const Icon(Icons.mic),
                label: const Text("Start Recording"),
              ),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/recording_indicator.dart';
import '../api/recallit_api.dart';
import 'dart:convert';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;
  String answer = '';
  String transcript = '';

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/recallit_${DateTime.now().millisecondsSinceEpoch}.m4a';
    print('[RecallIt] Audio will be recorded to: $_filePath');
  }

  Future<void> _startRecording() async {
    if (_filePath == null) return;

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacMP4,
    );

    setState(() {
      _isRecording = true;
    });

    print('[RecallIt] Recording started...');
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();

    setState(() {
      _isRecording = false;
    });

    print('[RecallIt] Recording stopped.');
    print('[RecallIt] File saved at: $_filePath');

    if (_filePath != null) {
      final base64Audio = await convertAudioToBase64(_filePath!);
      final response = await sendAudioToLambda(base64Audio);
      final outer = jsonDecode(response.body);
      final inner = jsonDecode(outer['body']);

      setState(() {
        answer = inner['answer'] ?? inner['summary'] ?? '';
        transcript = inner['transcript'] ?? '';
      });

      print('[RecallIt] Transcript: $transcript');
      print('[RecallIt] Answer: $answer');
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEBFA),
      appBar: AppBar(title: const Text('RecallIT AI')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isRecording
                ? RecordingIndicator(onStop: _stopRecording)
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF6750A4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _startRecording,
                    icon: const Icon(Icons.mic),
                    label: const Text("Tell me !!"),
                  ),
            const SizedBox(height: 24),

            // Display result
            if (answer.isNotEmpty) ...[
              const Text("You Asked:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(transcript, style: const TextStyle(fontStyle: FontStyle.italic)),

              const SizedBox(height: 12),
              const Text("Your Tasks:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(answer),
            ],
          ],
        ),
      ),
    );
  }
}
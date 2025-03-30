import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/recording_indicator.dart';
import 'package:share_plus/share_plus.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();

    final dir = await getTemporaryDirectory();
    _filePath = '${dir.path}/recallit_${DateTime.now().millisecondsSinceEpoch}.aac';

    print('[RecallIt] Audio will be recorded to: $_filePath');
  }

  Future<void> _startRecording() async {
    if (_filePath == null) return;

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacADTS,
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
                  label: const Text("Start Recording"),
                ),
          const SizedBox(height: 24),

          // Share button appears if recording is NOT in progress and a file is available
          if (!_isRecording && _filePath != null)
            ElevatedButton.icon(
              onPressed: () {
                Share.shareXFiles(
                  [XFile(_filePath!)],
                  text: 'Here’s my voice note from RecallIt AI!',
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share Recording'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
  
}
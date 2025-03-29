import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Important for plugin safety
  runApp(RecallItApp());
}

class RecallItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecallIt AI',
      home: VoiceRecorder(),
    );
  }
}

class VoiceRecorder extends StatefulWidget {
  @override
  _VoiceRecorderState createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isRecorderReady = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    print('[RecallIt] Initializing recorder...');
    if (Platform.isIOS || Platform.isAndroid) {
      final status = await Permission.microphone.request();
      print('[RecallIt] Mic permission status: $status');
    }

    try {
      await _recorder.openRecorder();
      print('[RecallIt] Recorder opened!');
      setState(() {
        _isRecorderReady = true;
      });
    } catch (e) {
      print('[RecallIt] Error opening recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady) return;

    Directory tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/voice_record.aac';

    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();

    setState(() {
      _isRecording = false;
    });

    print('[RecallIt] Audio file saved at: $_filePath');
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RecallIt AI')),
      body: Center(
        child: ElevatedButton(
          onPressed: !_isRecorderReady
              ? null
              : (_isRecording ? _stopRecording : _startRecording),
          child: Text(
            !_isRecorderReady
                ? 'Initializing...'
                : _isRecording
                    ? 'Stop Recording'
                    : 'Start Recording',
          ),
        ),
      ),
    );
  }
}
// lib/widgets/recording_indicator.dart

import 'dart:async';
import 'package:flutter/material.dart';

class RecordingIndicator extends StatefulWidget {
  final VoidCallback onStop;

  const RecordingIndicator({Key? key, required this.onStop}) : super(key: key);

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _timer;
  int _recordingDuration = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _stopRecording() {
    _timer.cancel();
    _animationController.stop();
    widget.onStop();
  }

  @override
  Widget build(BuildContext context) {
    final Color recordingColor = Color(0xFF6750A4); // Bluish-purple tone
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _animationController.value,
              child: const Icon(
                Icons.mic,
                size: 20,
                color: Color(0xFF6750A4),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          _formatDuration(_recordingDuration),
          style: const TextStyle(fontSize: 20, color: Color(0xFF6750A4)),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Color(0xFF6750A4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: _stopRecording,
          icon: const Icon(Icons.stop),
          label: const Text("Stop Recording"),
        ),
      ],
    );
  }
}
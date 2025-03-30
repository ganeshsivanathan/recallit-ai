import 'package:flutter/material.dart';

class RememberingText extends StatefulWidget {
  const RememberingText({super.key});

  @override
  _RememberingTextState createState() => _RememberingTextState();
}

class _RememberingTextState extends State<RememberingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<String> _dots = ['', '.', '..', '...'];
  int _dotIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _dotIndex = (_dotIndex + 1) % _dots.length;
        });
        _controller.forward(from: 0.0); // Restart animation
      }
    });

    _controller.forward(); // Start the loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Remembering${_dots[_dotIndex]}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w100,
        color: Color(0xFF6750A4),
      ),
    );
  }
}
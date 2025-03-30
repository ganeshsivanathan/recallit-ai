// lib/widgets/share_record.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareRecord extends StatelessWidget {
  final String filePath;

  const ShareRecord({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await Share.shareXFiles([XFile(filePath)], text: 'Here’s my voice note');
      },
      icon: const Icon(Icons.share),
      label: const Text("Share Recording"),
    );
  }
}
// ignore_for_file: file_names
import 'package:flutter/material.dart';

class TextSmall extends StatefulWidget {
  final String label;
  const TextSmall({super.key, required this.label});

  @override
  State<TextSmall> createState() => _TextSmallState();
}

class _TextSmallState extends State<TextSmall> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}

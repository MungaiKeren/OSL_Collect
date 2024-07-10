// ignore_for_file: file_names
import 'package:flutter/material.dart';

class TextResponse extends StatefulWidget {
  final String label;
  const TextResponse({super.key, required this.label});

  @override
  State<TextResponse> createState() => _TextResponseState();
}

class _TextResponseState extends State<TextResponse> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Text(
          widget.label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class MyRowII extends StatefulWidget {
  final String title;
  const MyRowII({super.key, required this.title});

  @override
  State<MyRowII> createState() => _MyRowIIState();
}

class _MyRowIIState extends State<MyRowII> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.white,
      radius: const Radius.circular(10),
      borderType: BorderType.RRect,
      dashPattern: const [4, 2],
      strokeWidth: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/customforms.png',
              width: 80, // Set the desired width
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: file_names
import 'package:flutter/material.dart';

class MyRowIII extends StatefulWidget {
  final String no;
  final String title;

  const MyRowIII({
    super.key,
    required this.no,
    required this.title,
  });

  @override
  State<MyRowIII> createState() => _MyRowIIIState();
}

class _MyRowIIIState extends State<MyRowIII> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color.fromRGBO(203, 203, 200, 1.0),
          width: 6,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  color: Color.fromRGBO(0, 47, 108, 1.0),
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.no,
              style: const TextStyle(
                color: Color.fromARGB(255, 0xBA, 0x0C, 0x2F), // Green color
              ),
            ),
          ],
        ),
      ),
    );
  }
}

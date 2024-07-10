// ignore_for_file: file_names
import 'package:flutter/material.dart';

class SmallButton extends StatefulWidget {
  final String label;
  final Color color;
  final Function? onButtonPressed;

  SmallButton({
    required this.label,
    required this.color,
    this.onButtonPressed,
  });

  @override
  State<SmallButton> createState() => _SmallButtonState();
}

class _SmallButtonState extends State<SmallButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onButtonPressed as void Function()?,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color, // Set the button color
        padding: const EdgeInsets.all(16.0), // Set button padding
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10), // Adjust the radius as needed
        ),
      ),
      child: Text(
        widget.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

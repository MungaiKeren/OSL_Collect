// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';

class DialogSubmit extends StatefulWidget {
  final String label;
  final onButtonPressed;
  const DialogSubmit({super.key, required this.label, this.onButtonPressed});

  @override
  State<DialogSubmit> createState() => _DialogSubmitState();
}

class _DialogSubmitState extends State<DialogSubmit> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onButtonPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(248, 249, 251, 1.0),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black.withOpacity(0.7)),
          ),
        ),
      ),
    );
  }
}

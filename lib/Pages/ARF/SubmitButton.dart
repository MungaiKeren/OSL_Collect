// ignore_for_file: file_names
import 'dart:ui';

import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final String label;
  final Function() onButtonPressed;
  const SubmitButton(
      {super.key, required this.label, required this.onButtonPressed});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(0, 100, 182, 1),
              Color.fromRGBO(29, 117, 163, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                blurRadius: 10) //blur radius of shadow
          ]),
      child: ElevatedButton(
        onPressed: widget.onButtonPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0)),
        child: Text(
          widget.label,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

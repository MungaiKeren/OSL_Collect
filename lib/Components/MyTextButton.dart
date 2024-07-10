// ignore_for_file: file_names, must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';

class MyTextButton extends StatefulWidget {
  final String label;
  final Color myColor;
  final String active;

  dynamic onButtonPressed;
  MyTextButton(
      {super.key,
      required this.label,
      this.onButtonPressed,
      required this.myColor, required this.active});

  @override
  State<MyTextButton> createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
    var colors = Colors.blue;

  @override
  void initState() {
    setState(() {
      colors = widget.active == widget.label ? Colors.blue : Colors.grey;
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onButtonPressed,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: widget.myColor),
          ),
        ),
      ),
    );
  }
}

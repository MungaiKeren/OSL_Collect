// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CFormInput extends StatefulWidget {
  String label;
  int lines;
  dynamic type;
  Function(String) onSubmit;

  CFormInput(
      {super.key,
      required this.label,
      required this.lines,
      required this.type,
      required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _CFormInputState();
}

class _CFormInputState extends State<CFormInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CFormInput oldWidget) {
    super.didUpdateWidget(oldWidget);
   
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 0xBA, 0x0C, 0x2F), // Green color
                  width: 2.0, // Adjust the width as needed
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _controller.value = TextEditingValue(
                    text: value,
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: value.length),
                    ),
                  );
                });
                widget.onSubmit(value);
              },
              keyboardType: widget.type,
              controller: _controller,
              maxLines: widget.lines,
              obscureText:
                  widget.type == TextInputType.visiblePassword ? true : false,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(
                  color: Color.fromARGB(
                      255, 0x00, 0x0C, 0x2F)), // Set the text color to white
            )),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

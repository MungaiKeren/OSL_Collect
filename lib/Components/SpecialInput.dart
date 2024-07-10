// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';

class SpecialInput extends StatefulWidget {
  String hint;
  String value;
  int lines;
  var type;
  IconData icon;
  Function(String) onSubmit;

  SpecialInput(
      {super.key,
      required this.hint,
      required this.lines,
      required this.value,
      required this.type,
      required this.icon,
      required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _SpecialInputState();
}

class _SpecialInputState extends State<SpecialInput> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SpecialInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != "") {
      setState(() {
        _controller.value = TextEditingValue(
          text: widget.value,
          selection: TextSelection.fromPosition(
            TextPosition(offset: widget.value.length),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 0xBA, 0x0C, 0x2F), // Green color
              width: 2.0, // Adjust the width as needed
            ),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                widget.icon,
                color: Color.fromRGBO(0, 44, 178, 1),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
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

                decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(3, 48, 109, 1),
                    ),
                    focusedBorder: InputBorder.none),
              ),
            ),
          ],
        ));
  }
}

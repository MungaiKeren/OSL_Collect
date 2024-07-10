// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextInput extends StatefulWidget {
  final String title;
  final String value;
  final int lines;
  final TextInputType type;
  final Function(dynamic) onSubmit;

  const MyTextInput(
      {super.key,
      required this.title,
      required this.lines,
      required this.value,
      required this.type,
      required this.onSubmit});

  @override
  State<StatefulWidget> createState() => _MyTextInputState();
}

class _MyTextInputState extends State<MyTextInput> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _controller.text =
            widget.value != "null" ? widget.value.toString() : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          hintColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)))),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: TextField(
              onChanged: (value) {
                widget.onSubmit(value);
              },
              keyboardType: widget.type,
              inputFormatters: widget.type ==
                      const TextInputType.numberWithOptions(decimal: false)
                  ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
                  : null,
              controller: _controller,
              maxLines: widget.lines,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              obscureText:
                  widget.type == TextInputType.visiblePassword ? true : false,
              enableSuggestions: true,
              autocorrect: false,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  hintStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  focusColor: Colors.red,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                  filled: false,
                  label: Text(
                    widget.title.toString(),
                    style: const TextStyle(color: Colors.white54),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto))),
    );
  }
}

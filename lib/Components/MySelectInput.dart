import 'package:flutter/material.dart';

class MySelectInput extends StatefulWidget {
  final String label;
  final String value;
  final List<String> list;
  final Function(String) onSubmit;
  const MySelectInput(
      {super.key,
      required this.list,
      required this.label,
      required this.onSubmit,
      required this.value});

  @override
  State<StatefulWidget> createState() => _MySelectInputState();
}

class _MySelectInputState extends State<MySelectInput> {
  late String _selectedOption;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedOption =
          widget.value != "" && widget.value != "null" && widget.value != "0"
              ? widget.value
              : widget.list.first;
    });
  }

  @override
  void didUpdateWidget(covariant MySelectInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _selectedOption = widget.value != "" && widget.value != "null" &&
                widget.value != "0"
            ? widget.value
            : widget.list.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          canvasColor: Colors.blue,
          hintColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow)))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Stack(
          children: [
            TextField(
              onChanged: (value) {},
              onTap: () {},
              enabled: false,
              enableSuggestions: false,
              autocorrect: false,
              style: const TextStyle(color: Colors.transparent),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  hintStyle: const TextStyle(color: Colors.white54),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 0.0),
                  ),
                  focusColor: Colors.yellow,
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow, width: 1.0)),
                  filled: false,
                  label: Text(
                    widget.label,
                    style: const TextStyle(color: Colors.white54),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 16, 0),
              child: DropdownButton<String>(
                icon: const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
                isExpanded: true,
                underline: Container(),
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                  widget.onSubmit(newValue!);
                },
                items:
                    widget.list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

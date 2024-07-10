// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CFormSelect extends StatefulWidget {
  final String value;
  final String label;
  final List<dynamic> entries;
  final Function(dynamic) onSubmit;

  const CFormSelect(
      {super.key,
      required this.onSubmit,
      required this.entries,
      required this.value,
      required this.label});

  @override
  State<StatefulWidget> createState() => _CFormSelectState();
}

class _CFormSelectState extends State<CFormSelect> {
  List<DropdownMenuItem<dynamic>> menuItems = [];
  String selected = "";

  @override
  void initState() {
    if (widget.entries.isNotEmpty) {
      setState(() {
        if (widget.entries.contains(widget.value)) {
          selected = widget.value;
        } else {
          selected = widget.entries[0];
        }
        menuItems = widget.entries
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList();
      });
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CFormSelect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.entries.isNotEmpty) {
      setState(() {
        if (widget.entries.contains(widget.value)) {
          selected = widget.value;
        } else {
          selected = widget.entries[0];
        }
        menuItems = widget.entries
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList();
      });
    }
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
          child: DropdownButtonFormField(
            items: menuItems,
            value: selected,
            onChanged: widget.onSubmit,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(0, 128, 0, 1))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.transparent), // Set transparent border
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

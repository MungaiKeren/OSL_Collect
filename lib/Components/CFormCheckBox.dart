// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CFormCheckBox extends StatefulWidget {
  final Set<String> selectedValues;
  final String label;
  final List<dynamic> entries;
  final Function(Set<String>) onSubmit;

  const CFormCheckBox({
    super.key,
    required this.onSubmit,
    required this.entries,
    required this.selectedValues,
    required this.label,
  });

  @override
  State<StatefulWidget> createState() => _CFormCheckBoxState();
}

class _CFormCheckBoxState extends State<CFormCheckBox> {
  late Set<String> selectedValues;

  @override
  void initState() {
    super.initState();
    selectedValues = widget.selectedValues.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            widget.entries.length,
            (index) => CheckboxListTile(
              title: Text(widget.entries[index]),
              value: selectedValues.contains(widget.entries[index]),
              onChanged: (bool? newValue) {
                setState(() {
                  if (newValue!) {
                    selectedValues.add(widget.entries[index] as String);
                  } else {
                    selectedValues.remove(widget.entries[index] as String);
                  }
                  widget.onSubmit(selectedValues);
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

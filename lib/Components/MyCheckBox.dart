import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(List<String>) onSubmit;

  const MyCheckBox({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  late List<bool> _isSelectedList;

  @override
  void initState() {
    super.initState();
    _isSelectedList = List.generate(widget.options.length, (index) {
      return widget.selectedOptions.contains(widget.options[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  _isSelectedList[index] = !_isSelectedList[index];
                  _updateSelectedOptions();
                });
              },
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        width: 24,
                        height: 24,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white, // Border color
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: _isSelectedList[index]
                            ? Icon(
                                Icons.check,
                                size: 18,
                                color: Colors.blue[100], // Tick color
                              )
                            : null,
                      ),
                      Text(
                        widget.options[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _updateSelectedOptions() {
    List<String> selectedOptions = [];
    for (int i = 0; i < _isSelectedList.length; i++) {
      if (_isSelectedList[i]) {
        selectedOptions.add(widget.options[i]);
      }
    }
    widget.onSubmit(selectedOptions);
  }
}

// ignore_for_file: file_names, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CFormDate extends StatefulWidget {
  final String? restorationId;
  String hint = 'Tap To Select Date';
  String label;
  int lines;
  dynamic type;
  Function(String) onSubmit;
  CFormDate(
      {super.key,
      this.restorationId,
      required this.label,
      required this.lines,
      required this.type,
      required this.onSubmit});
  @override
  _CFormDateState createState() => _CFormDateState();
}

class _CFormDateState extends State<CFormDate> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final TextEditingController _controller = TextEditingController();

  final RestorableDateTime _selectedDate = RestorableDateTime(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = DateTime(
          newSelectedDate.year,
          newSelectedDate.month,
          newSelectedDate.day,
        );
        _controller.value = TextEditingValue(
          text:
              "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}",
          selection: TextSelection.fromPosition(
            TextPosition(
              offset:
                  "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}"
                      .length,
            ),
          ),
        );
      });
      widget.onSubmit(
          "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}");
    }
  }

    @override
  void didUpdateWidget(covariant CFormDate oldWidget) {
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
              onTap: () {
                _restorableDatePickerRouteFuture.present();
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
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(3, 48, 109, 1),
                  ),
                  border: InputBorder.none),
            )),
      ],
    );
  }
}

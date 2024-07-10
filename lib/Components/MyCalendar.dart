// ignore_for_file: file_names, library_private_types_in_public_api, must_be_immutable
import 'package:flutter/material.dart';

class MyCalendar extends StatefulWidget {
  final String? restorationId;
  final String value;
  final String label;
  final String hint = 'Tap To Select Date';
  final Function(String) onSubmit;
  final int lines;
  dynamic type;

  MyCalendar(
      {super.key,
      this.restorationId,
      required this.value,
      required this.label,
      required this.lines,
      required this.onSubmit});

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> with RestorationMixin {
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
  void didUpdateWidget(covariant MyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _controller.text = widget.value.toString();
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
            _controller.value = TextEditingValue(
              text: value,
              selection: TextSelection.fromPosition(
                TextPosition(offset: value.length),
              ),
            );
            widget.onSubmit(value);
          },
          onTap: () {
            _restorableDatePickerRouteFuture.present();
          },
          keyboardType: widget.type,
          controller: _controller,
          readOnly: true,
          enableInteractiveSelection: false,
          maxLines: widget.lines,
          obscureText:
              widget.type == TextInputType.visiblePassword ? true : false,
          enableSuggestions: false,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
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
                widget.label,
                style: const TextStyle(color: Colors.white54),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto),
        ),
      ),
    );
  }
}

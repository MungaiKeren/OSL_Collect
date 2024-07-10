// ignore_for_file: file_names, must_be_immutable
import 'package:flutter/material.dart';

class WorkPlanCalendar extends StatefulWidget {
  final String? restorationId;
  Function(String) onSubmit;
  int lines;
  var type;

  WorkPlanCalendar({
    Key? key,
    this.restorationId,
    required this.lines,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _WorkPlanCalendarState createState() => _WorkPlanCalendarState();
}

class _WorkPlanCalendarState extends State<WorkPlanCalendar>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );
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
          lastDate: DateTime(2099),
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
        widget.onSubmit(
          "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          _restorableDatePickerRouteFuture.present();
        },
        child: Text(
          "${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}",
          style: TextStyle(
              color: Color.fromRGBO(3, 48, 110, 1),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

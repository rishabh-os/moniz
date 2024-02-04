import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    required this.initialDate,
    required this.returnSelectedDate,
  });
  final Function(DateTime selectedDate) returnSelectedDate;
  final DateTime initialDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  // ? Have to init with non-null value
  late DateTime displayDate;
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        displayDate = picked;
        widget.returnSelectedDate(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    displayDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    // ? Returns the value whenever the widget is rebuilt

    return OutlinedButton.icon(
      icon: const Icon(
        Icons.today,
        size: 16,
      ),
      label: Text(DateFormat("EEE, d MMM yyyy").format(displayDate)),
      onPressed: () => _selectDate2(context),
    );
  }
}

class TimePicker extends StatefulWidget {
  const TimePicker(
      {super.key, required this.initialTime, required this.returnSelectedTime});
  final Function(TimeOfDay selectedTime) returnSelectedTime;
  final TimeOfDay initialTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    // ? Returns the value whenever the widget is rebuilt

    return OutlinedButton.icon(
      icon: const Icon(
        Icons.access_time_filled,
        size: 16,
      ),
      label: Text(
          '${selectedTime.hourOfPeriod.toString().padLeft(2, "0")}: ${selectedTime.minute.toString().padLeft(2, "0")} ${selectedTime.period.name.toUpperCase()}'),
      onPressed: () async {
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: widget.initialTime,
          initialEntryMode: TimePickerEntryMode.dial,
          builder: (BuildContext context, Widget? child) {
            return child!;
          },
        );
        setState(() {
          selectedTime = time ?? selectedTime;
          widget.returnSelectedTime(selectedTime);
        });
      },
    );
  }
}

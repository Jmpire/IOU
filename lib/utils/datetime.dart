import 'package:flutter/material.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.light(
                  onPrimary: Colors.white, // selected text color
                  onSurface: Colors.grey, // default text color
                  primary: Colors.black // circle color

                  ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!);
      });

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.light(
                  onPrimary: Colors.white, // selected text color
                  onSurface: Colors.grey, // default text color
                  primary: Colors.black // circle color

                  ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!);
      });

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}

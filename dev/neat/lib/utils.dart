import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String> selectDate(BuildContext context, dynamic model, String date) async {
  DateTime initialDate = date != null ?  toDate(date) : DateTime.now();
  DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
  if (picked != null) {
    model.setChosenDate(DateFormat.yMMMMd('en_US').format(picked.toLocal()));
  }
  return "${picked.year},${picked.month},${picked.day}";
}

Color toColor(String color) {
  switch (color) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'grey':
      return Colors.grey;
    case 'purple':
      return Colors.purple;
    default:
      return Colors.white;
  }
}

DateTime toDate(String date) {
  List<String> parts = date.split(",");
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

String toFormattedDate(String date) {
  return formatDate(toDate(date));
}

String formatDate(DateTime date) {
  return DateFormat.yMMMMd("en_US").format(date.toLocal());
}

TimeOfDay toTime(String time) {
  List<String> parts = time.split(",");
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}

String toFormattedTime(String time, BuildContext context) {
  List<String> parts = time.split(",");
  TimeOfDay at = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  return "${at.format(context)}";
}
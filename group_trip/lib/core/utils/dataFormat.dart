import 'package:intl/intl.dart';

String formatDateToDMY(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

String formatCurrency(double value) {
    if (value == 0) return "0đ";
    final str = value.toStringAsFixed(0);
    final formatted = str.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    );
    return "$formattedđ";
}

DateTime combineDate(DateTime date) {
  final now = DateTime.now();
  return DateTime(
    date.year,
    date.month,
    date.day,
    now.hour,
    now.minute,
    now.second,
    now.millisecond,
  ).toUtc();
}

import 'dart:io';

import 'package:intl/intl.dart';

String formatDateToDMY(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

String formatDateToDMYString(String dateString) {
  final date = DateTime.parse(dateString);
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
String formatIntCurrency(int value) {
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


  String FormatFileSize(File? f) {
    if (f == null) return '';
    try {
      final bytes = f.lengthSync();
      if (bytes < 1024) return '$bytes B';
      final kb = bytes / 1024;
      if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(2)} MB';
    } catch (_) {
      return '';
    }
  }
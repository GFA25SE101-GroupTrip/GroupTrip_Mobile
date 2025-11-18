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


String formatDateRange(String start, String end) {
  try {
    final startDate = DateTime.parse(start);
    final endDate = DateTime.parse(end);

    String s = "${startDate.day}/${startDate.month}/${startDate.year}";
    String e = "${endDate.day}/${endDate.month}/${endDate.year}";

    return "$s đến $e";

  } catch (e) {
    return "";
  }
}


String FormatMessageTime(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime);
    final now = DateTime.now();
    final localTime = dateTime.toLocal();
    
    // Nếu là hôm nay
    if (localTime.year == now.year && 
        localTime.month == now.month && 
        localTime.day == now.day) {
      return DateFormat('HH:mm').format(localTime);
    }
    
    // Nếu là hôm qua
    final yesterday = now.subtract(const Duration(days: 1));
    if (localTime.year == yesterday.year && 
        localTime.month == yesterday.month && 
        localTime.day == yesterday.day) {
      return 'Hôm qua ${DateFormat('HH:mm').format(localTime)}';
    }
    
    // Nếu là năm nay
    if (localTime.year == now.year) {
      return DateFormat('dd/MM HH:mm').format(localTime);
    }
    
    // Khác năm
    return DateFormat('dd/MM/yyyy HH:mm').format(localTime);
  } catch (e) {
    return '';
  }
}

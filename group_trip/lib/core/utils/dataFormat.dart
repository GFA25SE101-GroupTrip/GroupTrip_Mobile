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

String formatDateTimeWithTime(String dateString) {
  final date = DateTime.parse(dateString);
  final formatter = DateFormat('HH:mm dd/MM/yyyy');
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
    // Parse thời gian từ backend (có thể là UTC với Z hoặc local time không có Z)
    final dateTime = DateTime.parse(isoTime);
    
    // 🔑 Nếu backend gửi không có 'Z' → đã là local time, dùng trực tiếp
    // Nếu có 'Z' → là UTC, cần .toLocal() để convert sang múi giờ device
    final displayTime = dateTime; // Giả sử backend gửi đúng múi giờ Việt Nam (1:26)
    
    // So sánh với ngày hôm nay
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(displayTime.year, displayTime.month, displayTime.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    
    // Hôm nay: hiển thị HH:mm
    if (messageDate == today) {
      return '${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}';
    }
    
    // Hôm qua: hiển thị "Hôm qua HH:mm"
    if (messageDate == yesterday) {
      return 'Hôm qua ${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}';
    }
    
    // Năm nay (nhưng trước hôm qua): hiển thị dd/MM HH:mm
    if (displayTime.year == now.year) {
      return '${displayTime.day.toString().padLeft(2, '0')}/${displayTime.month.toString().padLeft(2, '0')} ${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}';
    }
    
    // Khác năm: hiển thị đầy đủ dd/MM/yyyy HH:mm
    return '${displayTime.day.toString().padLeft(2, '0')}/${displayTime.month.toString().padLeft(2, '0')}/${displayTime.year} ${displayTime.hour.toString().padLeft(2, '0')}:${displayTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    print('❌ FormatMessageTime error: $e, isoTime: $isoTime');
    return '';
  }
}

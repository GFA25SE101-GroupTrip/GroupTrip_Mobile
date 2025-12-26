import 'package:flutter/material.dart';

class TrackingPhaseHelper {
  static String getStatusLabel(String status) {
    final low = status.toLowerCase();
    if (low.contains('ready') || low.contains('full')) return 'Đợi chốt nhóm';
    if (low.contains('inprogress')) return 'Đang diễn ra';
    if (low.contains('completed')) return 'Hoàn thành';
    if (low.contains('canceled')) return 'Đã hủy';
    if (low.contains('deposit')) return 'Chờ coc';
    if (low.contains('fullpayment')) return 'Chờ thanh toán';
    if (low.contains('pending')) return 'Chờ xác nhận';
    return status;
  }

  static Color getStatusColor(String status) {
    final low = status.toLowerCase();
    if (['ready', 'full', 'fullpayment', 'deposit', 'pending']
        .any((s) => low.contains(s))) {
      return Colors.orange;
    }
    if (low.contains('inprogress')) return Colors.green;
    if (low.contains('completed')) return Colors.grey;
    if (low.contains('canceled')) return Colors.red;
    return Colors.blueGrey;
  }

  static String getPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }
   static String getSegmentPhaseLabel(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return 'Sắp diễn ra';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Đang diễn ra';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return phase;
  }

  static Color getPhaseColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return Colors.orange;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.blue;
    if (low.contains('completed')) return Colors.green;
    return Colors.grey;
  }

  static String getActivityButtonText(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return 'Check-in';
    if (low.contains('inprogress') || low.contains('progress'))
      return 'Kết thúc';
    if (low.contains('completed')) return 'Đã hoàn thành';
    return 'Check-in';
  }

  static Color getActivityButtonColor(String phase) {
    final low = phase.toLowerCase();
    if (low.contains('upcomming')) return Colors.blue.shade600;
    if (low.contains('inprogress') || low.contains('progress'))
      return Colors.orange.shade600;
    if (low.contains('completed')) return Colors.green.shade600;
    return Colors.grey.shade600;
  }
}

import 'package:flutter/material.dart';

class CancelSummaryRow {
  final String label;
  final String value;
  final Color? color;

  CancelSummaryRow(this.label, this.value, {this.color});
}

class CancelSummaryModel {
  final String reason;
  final String refundAmount;
  final String paymentMethod;
  final String estimatedTime;

  CancelSummaryModel({
    required this.reason,
    required this.refundAmount,
    required this.paymentMethod,
    required this.estimatedTime,
  });

  static CancelSummaryModel mock() => CancelSummaryModel(
    reason: 'Không đủ thành viên',
    refundAmount: '5.500.000 VND',
    paymentMethod: 'Chuyển khoản ngân hàng',
    estimatedTime: '5–7 ngày làm việc',
  );

  List<CancelSummaryRow> toRows() => [
    CancelSummaryRow("Lý do hủy", reason, color: const Color(0xFFDC2626)),
    CancelSummaryRow(
      "Số tiền hoàn lại",
      refundAmount,
      color: const Color(0xFF16A34A),
    ),
    CancelSummaryRow("Phương thức thanh toán", paymentMethod),
    CancelSummaryRow("Thời gian dự kiến", estimatedTime),
  ];
}

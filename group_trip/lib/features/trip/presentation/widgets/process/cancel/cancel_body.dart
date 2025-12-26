import 'package:flutter/material.dart' hide TabBar;
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_contact.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_notice.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_policy.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_summary.dart';


class CancelBody extends StatefulWidget {
  final String imageUrl;
  final String? reason;
  final int? refundAmount;
  final String? paymentMethod;
  final String? estimatedTime;

  const CancelBody({
    super.key,
    required this.imageUrl,
    this.reason,
    this.refundAmount,
    this.paymentMethod,
    this.estimatedTime,
  });

  @override
  State<CancelBody> createState() => _CancelBodyState();
}

class _CancelBodyState extends State<CancelBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
                        SizedBox(height: 12),
                        CancelSummary(
                          reason: widget.reason,
                          refundAmount: widget.refundAmount,
                          paymentMethod: widget.paymentMethod,
                          estimatedTime: widget.estimatedTime,
                        ),
                        SizedBox(height: 24),
                       
                        SizedBox(height: 24),
                        CancelPolicy(),
                        SizedBox(height: 160),
                      ],
                    ),
    );
  }
}
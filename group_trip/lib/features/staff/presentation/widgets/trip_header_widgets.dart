import 'package:flutter/material.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:intl/intl.dart';

class TripHeaderWidget extends StatelessWidget {
  final DepartureStaff trip;

  const TripHeaderWidget({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      child: trip.tripImages.isNotEmpty
          ? Image.network(
              trip.tripImages.first,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.photo, size: 80, color: Colors.grey),
            )
          : const Icon(Icons.photo, size: 80, color: Colors.grey),
    );
  }
}

class TripInfoWidget extends StatelessWidget {
  final DepartureStaff trip;
  final ThemeData theme;

  const TripInfoWidget({
    super.key,
    required this.trip,
    required this.theme,
  });

  Color _getStatusColor(String status) {
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

  String _getStatusLabel(String status) {
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tên chuyến
          Text(
            trip.tripName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Trạng thái
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: _getStatusColor(trip.departureStatus).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getStatusLabel(trip.departureStatus),
              style: theme.textTheme.bodySmall?.copyWith(
                color: _getStatusColor(trip.departureStatus),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Ngày
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${dateFormat.format(DateTime.parse(trip.startDate))} - ${dateFormat.format(DateTime.parse(trip.endDate))}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Số người
          Row(
            children: [
              Icon(Icons.people, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${trip.numberMemberIn} người',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactButtonWidget extends StatelessWidget {
  final String tripName;

  const ContactButtonWidget({
    super.key,
    required this.tripName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Liên hệ nhóm $tripName',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: const Icon(Icons.phone, color: Colors.white),
          label: const Text(
            'Liên hệ nhóm',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

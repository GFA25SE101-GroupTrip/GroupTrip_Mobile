import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
// departure model not required in this UI file


class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});

  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch once when the screen is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mytripNotifierProvider.notifier).fetchMyTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mytripNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyến đi của tôi'),
        centerTitle: true,
        elevation: 1,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Lỗi khi tải chuyến đi: $e')),
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('Không có chuyến đi'));
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => MyTripCard(model: items[index]),
          );
        },
      ),
    );
  }
}

class MyTripCard extends StatelessWidget {
  final MyTripModel model;
  const MyTripCard({super.key, required this.model});

  String formatRange(DateTime s, DateTime e) {
    if (s.year == 1970 || e.year == 1970) return 'Ngày không xác định';
    final df = DateFormat('dd MMM yyyy', 'vi');
    return '${df.format(s)} - ${df.format(e)}';
  }

  String daysUntilStart(DateTime start) {
    if (start.year == 1970) return '';
    final now = DateTime.now();
    final diff = start.difference(DateTime(now.year, now.month, now.day));
    final days = diff.inDays;
    if (days > 1) return '$days ngày nữa';
    if (days == 1) return '1 ngày nữa';
    if (days == 0) return 'Bắt đầu hôm nay';
    return 'Đã bắt đầu';
  }

  // Map backend status string to a friendly label and color
 String statusLabel(String s) {
  final low = s.toLowerCase();

  if (low.contains('ready')) return 'Đợi chốt nhóm';
  if (low.contains('deposit') || low.contains('full')) return 'Đang đặt cọc';
  if (low.contains('fullpayment')) return 'Đang thanh toán';
  if (low.contains('inprogress')) return 'Đang diễn ra';
  if (low.contains('completed')) return 'Hoàn thành';
  if (low.contains('canceled') || low.contains('cancel')) return 'Đã hủy';

  return s;
}

Color statusColor(String s) {
  final low = s.toLowerCase();

  if (low.contains('ready')) return Colors.orange;               // Đợi chốt nhóm
  if (low.contains('deposit') || low.contains('full')) return Colors.blue; // Đang đặt cọc
  if (low.contains('fullpayment')) return Colors.teal;           // Đang thanh toán
  if (low.contains('inprogress')) return Colors.green;           // Đang diễn ra
  if (low.contains('completed')) return Colors.grey;             // Hoàn thành
  if (low.contains('canceled') || low.contains('cancel')) return Colors.redAccent; // Đã hủy

  return Colors.blueGrey; // fallback
}


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = model.startDate;
    final end = model.endDate;
    final participants = model.numberMemberIn;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // open trip detail
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image or placeholder
              Container(
                width: 110,
                height: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                child: model.img.isNotEmpty
                    ? Image.network(model.img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.photo, size: 40, color: Colors.grey))
                    : const Icon(Icons.photo, size: 40, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            model.name,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor(model.tripStatus).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusLabel(model.departureStatus),
                            style: theme.textTheme.bodySmall?.copyWith(color: statusColor(model.tripStatus), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (start.year != 1970) ...[
                      Text(
                        formatRange(start, end),
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(daysUntilStart(start), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                    ] else ...[
                      Text('Chưa có lịch trình', style: theme.textTheme.bodySmall),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text('$participants người tham gia', style: theme.textTheme.bodySmall),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            minimumSize: const Size(0, 36),
                          ),
                          onPressed: () {},
                          child: const Text('Chi tiết'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

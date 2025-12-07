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
  late String _selectedStatus;
  
  final List<String> _statusOptions = ['UpComming', 'InProgress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _statusOptions[0];
    // Fetch once when the screen is inserted in the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: _selectedStatus);
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
      body: Column(
        children: [
          // Status tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusOptions.map((status) {
                  final isSelected = _selectedStatus == status;
                  final statusLabel = status == 'UpComming' 
                      ? 'Sắp tới' 
                      : status == 'InProgress'
                          ? 'Đang diễn ra'
                          : 'Hoàn thành';
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(statusLabel),
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                        // Fetch trips with new status
                        ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: status);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Trip list
          Expanded(
            child: state.when(
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
          ),
        ],
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
    final maxUsers = model.maxUsers;
    final isUserJoined = model.currentUserStatus.toLowerCase() == 'active';
    final isCanceled = model.cancelReason != null && model.cancelReason!.isNotEmpty;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          // open trip detail
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large image at top
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: model.img.isNotEmpty
                  ? Image.network(model.img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.photo, size: 50, color: Colors.grey))
                  : const Icon(Icons.photo, size: 50, color: Colors.grey),
            ),
            // Content below image
            Padding(
              padding: const EdgeInsets.all(12),
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
                          color: statusColor(model.departureStatus).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusLabel(model.departureStatus),
                          style: theme.textTheme.bodySmall?.copyWith(color: statusColor(model.departureStatus), fontWeight: FontWeight.bold),
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
                      Text('$participants/$maxUsers người', style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      // User status indicator
                      if (isUserJoined)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('Đã tham gia', 
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          minimumSize: const Size(100, 42),
                        ),
                        onPressed: () {},
                        child: const Text('Chi tiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  // Show cancel reason if trip is canceled
                  if (isCanceled) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Lý do hủy: ${model.cancelReason}',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.redAccent, fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
// departure model not required in this UI file
class MyTripsScreen extends ConsumerStatefulWidget { const MyTripsScreen({super.key}); @override ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState(); }

class _MyTripsScreenState extends ConsumerState<MyTripsScreen> {
  late String _selectedStatus;
  final List<String> _statusOptions = ['UpComming', 'InProgress', 'Completed'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _statusOptions[0];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: _selectedStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    // SỬ DỤNG ref ở đây (không truyền vào build)
    final state = ref.watch(mytripNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyến đi của tôi'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
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
                        ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: status);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
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
                itemBuilder: (context, index) => MyTripCard(
                  model: items[index],
                  onRejoinSuccess: () {
                    // Refetch current status when rejoin succeeds
                    ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: _selectedStatus);
                  },
                ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class MyTripCard extends ConsumerWidget {
  final MyTripModel model;
  final VoidCallback? onRejoinSuccess;
  const MyTripCard({super.key, required this.model, this.onRejoinSuccess});

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

  // Map currentUserStatus to friendly label
  String currentUserStatusLabel(String status) {
    final low = status.toLowerCase();
    
    if (low.contains('active')) return 'Đã tham gia';
    if (low.contains('inactive')) return 'Đã rời nhóm';
    if (low.contains('deposit')) return 'Đã đặt cọc';
    if (low.contains('fullpayment')) return 'Đã thanh toán';
    if (low.contains('refund')) return 'Được hoàn tiền';
    if (low.contains('refundeligible')) return 'Được trả cọc';
    
    return status;
  }

  // Map currentUserStatus to color
  Color currentUserStatusColor(String status) {
    final low = status.toLowerCase();
    
    if (low.contains('active')) return Colors.green;
    if (low.contains('inactive')) return Colors.red;
    if (low.contains('deposit')) return Colors.orange;
    if (low.contains('fullpayment')) return Colors.blue;
    if (low.contains('refund')) return Colors.purple;
    if (low.contains('refundeligible')) return Colors.amber;
    
    return Colors.grey;
  }

  Future<void> _handleRejoinTrip(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(mytripRejoinTripProvider(model.departureId).future);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tham gia chuyến đi thành công'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
        
        // Call the callback to refetch trips with current status
        onRejoinSuccess?.call();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final start = model.startDate;
    final end = model.endDate;
    final participants = model.numberMemberIn;
    final maxUsers = model.maxUsers;
    final isUserJoined = model.currentUserStatus.toLowerCase() == 'active' || model.currentUserStatus.toLowerCase() == 'deposit' || model.currentUserStatus.toLowerCase() == 'fullpayment'  || model.currentUserStatus.toLowerCase() == 'refund';
    final isCanceled = model.cancelReason != null && model.cancelReason!.isNotEmpty;
    final isUserInactive = model.currentUserStatus.toLowerCase() == 'inactive';
  
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUserInactive
                              ? Colors.red.withOpacity(0.12)
                              : currentUserStatusColor(model.currentUserStatus).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isUserInactive
                              ? 'Đã rời nhóm'
                              : currentUserStatusLabel(model.currentUserStatus),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isUserInactive
                                ? Colors.red
                                : currentUserStatusColor(model.currentUserStatus),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Button logic based on user status and departure status
                     if (isUserJoined || model.departureStatus.toLowerCase().contains('cancel'))
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: model.departureStatus.toLowerCase().contains('cancel') 
                                ? Colors.grey.shade600
                                : Colors.blue.shade600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            minimumSize: const Size(100, 42),
                          ),
                          onPressed: () {
                            // Navigate based on departure status
                            final status = model.departureStatus.toLowerCase();
                            if (status.contains('ready')) {
                              context.push(
                                '/pending-process/${model.departureId}',
                                extra: model.toJson(),
                              );
                            } else if (status.contains('inprogress') || status.contains('pending')) {
                              context.push(
                                '/inprogress_process/${model.departureId}',
                                extra: model.toJson(),
                              );
                            } else if (status.contains('completed')) {
                              context.push(
                                '/complete_process/${model.departureId}',
                                extra: model.toJson(),
                              );
                            } else if (status.contains('deposit') || status.contains('fullpayment') || status.contains('full')) {
                              context.push(
                                '/deposit_process/${model.departureId}',
                                extra: model.toJson(),
                              );
                            } else if (status.contains('canceled') || status.contains('cancel')) {
                              context.push(
                                '/canceled_process/${model.departureId}',
                                extra: model.toJson(),
                              );
                            }
                          },
                          child: const Text('Chi tiết', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        )
                      else if (model.departureStatus.toLowerCase().contains('ready'))
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            minimumSize: const Size(100, 42),
                          ),
                          onPressed: () => _handleRejoinTrip(context, ref),
                          child: const Text('Tham gia', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

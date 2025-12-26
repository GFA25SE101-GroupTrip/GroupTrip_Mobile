import 'package:flutter/material.dart';
import 'package:group_trip/features/staff/presentation/staff_trip_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/staff/presentation/providers/staff_provider.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';

class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  late String _selectedStatus;
  final List<String> _statusOptions = ['Sắp diễn ra', 'Đang diễn ra', 'Đã diễn ra'];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _statusOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    final tripsByStatus = ref.watch(staffTripsByStatusProvider(_selectedStatus));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyến đi của tôi'),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(staffDeparturesProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab filter
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _statusOptions.map((status) {
                  final isSelected = _selectedStatus == status;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(status),
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = status;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Trip list
          Expanded(
            child: tripsByStatus.when(
              data: (trips) {
                if (trips.isEmpty) {
                  return const Center(
                    child: Text('Không có chuyến đi'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.refresh(staffTripsByStatusProvider(_selectedStatus));
                    ref.refresh(staffDeparturesProvider);
                    ref.invalidate(staffDeparturesProvider);
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    itemCount: trips.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => Consumer(
                      builder: (context, ref, _) {
                        final tripData = ref.watch(staffDeparturesProvider);
                        return tripData.when(
                          data: (departures) {
                            final matching = departures.where(
                              (d) => d.tripName == trips[index].name,
                            ).firstOrNull;
                            return StaffTripCard(
                              trip: trips[index],
                              departureStaff: matching,
                            );
                          },
                          loading: () => StaffTripCard(
                            trip: trips[index],
                          ),
                          error: (_, __) => StaffTripCard(
                            trip: trips[index],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Lỗi: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StaffTripCard extends StatelessWidget {
  final StaffTripModel trip;
  final DepartureStaff? departureStaff;

  const StaffTripCard({
    super.key,
    required this.trip,
    this.departureStaff,
  });

  String statusLabel(String status) {
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

  Color statusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image at top
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: trip.image != null && trip.image!.isNotEmpty
                ? Image.network(
                    trip.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.photo, size: 50, color: Colors.grey),
                  )
                : const Icon(Icons.photo, size: 50, color: Colors.grey),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        trip.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor(trip.departureStatus).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        statusLabel(trip.departureStatus),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor(trip.departureStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date range
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${dateFormat.format(DateTime.parse(trip.startDate))} - ${dateFormat.format(DateTime.parse(trip.endDate))}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Members info
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${trip.memberCount} người',
                      style: theme.textTheme.bodySmall,
                    ),
                    const Spacer(),
                    // Route button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {
                        if (departureStaff != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StaffTripDetailScreen(
                                trip: departureStaff!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Không tìm thấy dữ liệu: ${trip.name}'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.map,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Lộ trình',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

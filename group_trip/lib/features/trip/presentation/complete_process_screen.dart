import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_header.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/complete_body.dart';

class CompleteProcessScreen extends ConsumerStatefulWidget {
  final String departureId;
  final Map<String, dynamic> tripData;

  static const routeName = '/complete_process';
  const CompleteProcessScreen({
    super.key,
    required this.departureId,
    required this.tripData,
  });

  @override
  ConsumerState<CompleteProcessScreen> createState() => _CompleteProcessScreenState();
}

class _CompleteProcessScreenState extends ConsumerState<CompleteProcessScreen> {
  late MyTripModel? _tripModel;

  @override
  void initState() {
    super.initState();
    // Parse trip data if available
    if (widget.tripData.isNotEmpty) {
      try {
        _tripModel = MyTripModel.fromJson(widget.tripData);
      } catch (e) {
        _tripModel = null;
        print('Error parsing trip data: $e');
      }
    } else {
      _tripModel = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayImageUrl = _tripModel?.img?.isNotEmpty == true
        ? _tripModel!.img
        : 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg2/800/400';

    final String displayTitle = _tripModel?.name ?? 'Chuyến đi đã hoàn thành';

    return Scaffold(
      body: Stack(
        children: [
          DepositHeader(
            imageUrl: displayImageUrl,
            title: displayTitle,
            statusLabel: 'Đã hoàn thành',
            remainingTime: '',
          ),
          RefreshIndicator(
            onRefresh: _refreshTripData,
            child: CompleteBody(
              imageUrl: displayImageUrl,
              tripModel: _tripModel,
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleIcon(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                _buildCircleIcon(
                  icon: Icons.share,
                  onTap: () => {print('share')},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshTripData() async {
    try {
      // Refetch trip data from API using mytripNotifierProvider
      await ref.read(mytripNotifierProvider.notifier).fetchMyTrips(status: 'Completed');
    } catch (e) {
      print('Error refreshing trip data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCircleIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

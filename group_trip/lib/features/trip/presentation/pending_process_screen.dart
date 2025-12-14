import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/pending/pending_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/pending/pending_header.dart';


class PendingProcessScreen extends ConsumerStatefulWidget {
  static const routeName = '/pending-process';
  final String departureId;
  final Map<String, dynamic> tripData;
  
  const PendingProcessScreen({
    super.key,
    required this.departureId,
    required this.tripData,
  });

  @override
  ConsumerState<PendingProcessScreen> createState() => _PendingProcessScreenState();
}

class _PendingProcessScreenState extends ConsumerState<PendingProcessScreen> {
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
    final imageUrl = _tripModel?.img ?? 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg2/800/400';
    final title = _tripModel?.name ?? 'Trekking Tà Năng - Phan Dũng';
    final remainingTime = _formatRemainingTime(_tripModel?.timeRemainToFullPay ?? '');
    final statusLabel = _getStatusLabel(_tripModel?.departureStatus);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(mytripTrackingRouteProvider(widget.departureId).future);
          print('✅ Refreshed trip data from pending process screen');
        },
        child: Stack(
          children: [
            PendingHeader(
              imageUrl: imageUrl,
              title: title,
              remainingTime: remainingTime,
              statusLabel: statusLabel,
            ),
            PendingBody(
              imageUrl: imageUrl,
              tripModel: _tripModel,
              departureId: widget.departureId,
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
      ),
    );
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

  String _formatRemainingTime(String timeRemainToFullPay) {
    if (timeRemainToFullPay.isEmpty) return '2d 14h left';
    
    try {
      // Parse the duration string (e.g., "2d 14h")
      final pattern = RegExp(r'(\d+)[dD]\s+(\d+)[hH]');
      final match = pattern.firstMatch(timeRemainToFullPay);
      
      if (match != null) {
        final days = match.group(1);
        final hours = match.group(2);
        return '$days days ${hours}h left';
      }
      
      return timeRemainToFullPay;
    } catch (e) {
      return '2d 14h left';
    }
  }

  String _getStatusLabel(String? departureStatus) {
    if (departureStatus == null) return 'Pending Confirmation';
    
    final status = departureStatus.toLowerCase();
    if (status.contains('ready')) {
      return 'Sẵn sàng khởi hành';
    } else if (status.contains('pending')) {
      return 'Chờ xác nhận';
    } else if (status.contains('cancelled')) {
      return 'Đã hủy';
    }
    
    return 'Pending Confirmation';
  }
}

import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/trip/data/trip_member.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/pending/pending_schedule.dart';

class TabContent extends StatelessWidget {
  final int selectedIndex;
  final MyTripModel? tripModel;

  const TabContent({
    super.key,
    required this.selectedIndex,
    this.tripModel,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: _buildContentByIndex(),
    );
  }

  Widget _buildContentByIndex() {
    switch (selectedIndex) {
      case 0:
        return PendingSchedule(departureId: tripModel?.departureId);
      case 1:
        return _buildMembersContent();
      default:
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text(
              'Nội dung đang được cập nhật...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        );
    }
  }

  Widget _buildMembersContent() {
    if (tripModel == null || tripModel!.tripMembers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Không có thành viên nào',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tripModel!.tripMembers.length,
      itemBuilder: (context, index) {
        final member = tripModel!.tripMembers[index];
        return _buildMemberItem(member);
      },
    );
  }

  Widget _buildMemberItem(TripMember member) {
    final statusColor = _getStatusColor(member.tripMemberStatus);
    final statusText = _getStatusText(member.tripMemberStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: member.imgUrl != null && member.imgUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      member.imgUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          (member.memberName?.isNotEmpty ?? false)
                              ? member.memberName![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      (member.memberName?.isNotEmpty ?? false) ? member.memberName![0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.memberName ?? 'Chưa cập nhật',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return Colors.grey;
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('active')) {
      return Colors.green;
    } else if (lowerStatus.contains('deposit') || lowerStatus.contains('fullpayment')) {
      return Colors.blue;
    } else if (lowerStatus.contains('refund')) {
      return Colors.orange;
    } else if (lowerStatus.contains('inactive')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _getStatusText(String? status) {
    if (status == null) return 'Chưa xác định';
    
    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('active')) {
      return 'Đang tham gia';
    } else if (lowerStatus.contains('inactive')) {
      return 'Đã rút khỏi';
    } else if (lowerStatus.contains('deposit')) {
      return 'Cọc';
    } else if (lowerStatus.contains('fullpayment')) {
      return 'Thanh toán đầy đủ';
    } else if (lowerStatus.contains('refund') && !lowerStatus.contains('eligible')) {
      return 'Đã hoàn tiền';
    } else if (lowerStatus.contains('refundeligible')) {
      return 'Có thể hoàn tiền';
    }
    return status;
  }
}

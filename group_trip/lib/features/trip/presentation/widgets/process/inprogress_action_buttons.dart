import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/core/api/contact.dart';

class InProgressActionButtons extends ConsumerStatefulWidget {
  final MyTripModel? tripModel;

  const InProgressActionButtons({super.key, this.tripModel});

  @override
  ConsumerState<InProgressActionButtons> createState() => _InProgressActionButtonsState();
}

class _InProgressActionButtonsState extends ConsumerState<InProgressActionButtons> {
  Future<void> _handleViewMap() async {
    print('View map clicked');
    // TODO: Implement map view logic
  }

  Future<void> _handleContactTrip() async {
    if (widget.tripModel == null || widget.tripModel!.departureId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể liên hệ chuyến đi')),
      );
      return;
    }

    try {
      final chatData = await ref.read(
        departureChatProvider(widget.tripModel!.departureId).future,
      );

      if (mounted && chatData != null) {
        final chatId = chatData['chatId'] ?? chatData['id'] ?? '';
        if (chatId.isNotEmpty) {
          context.push('/chat/$chatId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không tìm thấy thông tin chat')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleViewMap,
            icon: const Icon(Icons.map, color: Colors.white),
            label: const Text(
              'Xem bản đồ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _handleContactTrip,
            icon: const Icon(Icons.chat_bubble, color: Colors.white),
            label: const Text(
              'Liên hệ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

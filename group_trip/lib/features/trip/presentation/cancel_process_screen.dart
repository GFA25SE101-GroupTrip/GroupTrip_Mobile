import 'package:flutter/material.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_header.dart';


class CancelProcessScreen extends StatefulWidget {
  final String departureId;
  final Map<String, dynamic> tripData;

  static const routeName = '/canceled_process';
  const CancelProcessScreen({super.key, required this.departureId, required this.tripData});

  @override
  State<CancelProcessScreen> createState() => _CancelProcessScreenState();
}

class _CancelProcessScreenState extends State<CancelProcessScreen> {
  late MyTripModel? _tripModel;

  @override
  void initState() {
    super.initState();
    _parseAndUpdateTripData();
  }

  void _parseAndUpdateTripData() {
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
    
    final String displayTitle = _tripModel?.name ?? 'Trekking Tà Năng - Phan Dũng';
    final String cancelReason = _tripModel?.cancelReason ?? 'Chưa có lý do hủy';

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      CancelHeader(
                        imageUrl: displayImageUrl,
                        title: displayTitle,
                        cancelReason: cancelReason,
                      ),
                      CancelBody(imageUrl: displayImageUrl),
                    ],
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
          ),
        ],
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
}

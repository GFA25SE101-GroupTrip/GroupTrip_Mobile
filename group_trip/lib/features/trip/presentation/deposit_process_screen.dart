import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/mytrip/data/mytrip_model.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_header.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/deposit_paid/deposit_action_buttons.dart';


class DepositProcessScreen extends ConsumerStatefulWidget {
  final String departureId;
  final Map<String, dynamic> tripData;

  static const routeName = '/deposit_process';
  const DepositProcessScreen({super.key, required this.departureId, required this.tripData});

  @override
  ConsumerState<DepositProcessScreen> createState() => _DepositProcessScreenState();
}

class _DepositProcessScreenState extends ConsumerState<DepositProcessScreen> {

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
    
    // Determine remaining time based on departure status
    String displayRemainingTime = 'Chưa bắt đầu';
    if (_tripModel != null) {
      final status = _tripModel!.departureStatus.toLowerCase();
      if (status.contains('deposit')) {
        displayRemainingTime = _tripModel!.timeRemainToDeposit ?? 'Chưa bắt đầu';
      } else if (status.contains('fullpayment')) {
        displayRemainingTime = _tripModel!.timeRemainToFullPay ?? 'Chưa bắt đầu';
      }
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      DepositHeader(
                        imageUrl: displayImageUrl,
                        title: displayTitle,
                        statusLabel: _tripModel?.departureStatus ?? 'Deposit paid',
                        remainingTime: displayRemainingTime,
                      ),
                      DepositBody(
                        imageUrl: displayImageUrl,
                        tripModel: _tripModel,
                      ),
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
                      Row(
                        children: [
                          _buildCircleIcon(
                            icon: Icons.refresh,
                            onTap: () async {
                              await Future.wait([
                                ref.refresh(mytripTrackingRouteProvider(widget.departureId).future),
                                ref.refresh(mytripNotifierProvider.notifier).fetchMyTrips(),
                              ]);
                              if (mounted) {
                                setState(() {
                                  _parseAndUpdateTripData();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã làm mới dữ liệu'),
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildCircleIcon(
                            icon: Icons.share,
                            onTap: () => {print('share')},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E5E5)),
                ),
              ),
              child: DepositActionButtons(
                tripModel: _tripModel,
              ),
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

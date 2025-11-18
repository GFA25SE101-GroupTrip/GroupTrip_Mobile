import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/cancel/cancel_header.dart';


class CancelProcessScreen extends StatefulWidget {
  static const routeName = '/cancel_process';
  const CancelProcessScreen({super.key});

  @override
  State<CancelProcessScreen> createState() => _CancelProcessScreenState();
}

class _CancelProcessScreenState extends State<CancelProcessScreen> {
  final String imageUrl = 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg2/800/400';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CancelHeader(
            imageUrl: imageUrl,
            title: 'Trekking Tà Năng - Phan Dũng',
          ),
          CancelBody(imageUrl: imageUrl),
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

import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/pending/pending_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/pending/pending_header.dart';


class PendingProcessScreen extends StatefulWidget {
  static const routeName = '/pending_process';
  const PendingProcessScreen({super.key});

  @override
  State<PendingProcessScreen> createState() => _PendingProcessScreenState();
}

class _PendingProcessScreenState extends State<PendingProcessScreen> {
  final String imageUrl = 'https://res.cloudinary.com/db18zz55c/image/upload/v1762439871/uploads/scaled_38.jpg2/800/400';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PendingHeader(
            imageUrl: imageUrl,
            title: 'Trekking Tà Năng - Phan Dũng',
          ),
          PendingBody(imageUrl: imageUrl),
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

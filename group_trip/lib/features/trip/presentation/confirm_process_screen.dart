import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/confirm/confirm_body.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/confirm/confirm_header.dart';


class ConfirmProcessScreen extends StatefulWidget {
  static const routeName = '/confirm_process';
  const ConfirmProcessScreen({super.key});

  @override
  State<ConfirmProcessScreen> createState() => _ConfirmProcessScreenState();
}

class _ConfirmProcessScreenState extends State<ConfirmProcessScreen> {
  final String imageUrl = 'https://picsum.photos/seed/2/800/400';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ConfirmHeader(
            imageUrl: imageUrl,
            title: 'Trekking Tà Năng - Phan Dũng',
          ),
          ConfirmBody(imageUrl: imageUrl),
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

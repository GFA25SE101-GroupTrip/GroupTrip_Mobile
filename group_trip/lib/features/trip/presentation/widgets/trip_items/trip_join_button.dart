import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/presentation/pending_process_screen.dart';


class JoinTripButton extends StatelessWidget {
  final String departureId;
  final Map<String, dynamic> tripData;

  const JoinTripButton({
    super.key,
    required this.departureId,
    required this.tripData,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).push(MaterialPageRoute(
            builder: (_) => PendingProcessScreen(
              departureId: departureId,
              tripData: tripData,
            ),
          ));
        },
        child: const Text(
          'Tham gia chuyến đi',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

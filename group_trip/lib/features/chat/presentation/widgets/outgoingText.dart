import 'package:flutter/material.dart';

class OutgoingText extends StatelessWidget {
  final String message;
  final String? time;

  const OutgoingText({super.key, required this.message, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 4),
          if (time != null) Text(time!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color color;

  const SectionCard({super.key, required this.title, required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
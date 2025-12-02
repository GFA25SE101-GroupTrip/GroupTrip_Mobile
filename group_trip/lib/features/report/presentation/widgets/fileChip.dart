import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FileChip extends StatelessWidget {
  final String name; 
  final String size; 
  final IconData icon;
  final Color color;

  const FileChip({super.key, required this.name, required this.size, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style:
                      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
              Text(size,
                  style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}
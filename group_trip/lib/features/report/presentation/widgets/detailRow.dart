import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? trailingIcon;
  final Color? color;

  const DetailRow({super.key, required this.label, required this.value, this.trailingIcon, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: GoogleFonts.inter(fontSize: 14))),
          Expanded(
            child: Row(
              children: [
                if (trailingIcon != null)
                  Icon(trailingIcon, size: 14, color: color ?? Colors.grey),
                if (trailingIcon != null) const SizedBox(width: 4),
                Text(value,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        color: color ?? Colors.black,
                        fontWeight:
                            trailingIcon != null ? FontWeight.w500 : FontWeight.normal)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
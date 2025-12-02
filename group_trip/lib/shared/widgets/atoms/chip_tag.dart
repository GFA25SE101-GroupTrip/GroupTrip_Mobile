import 'dart:math';
import 'package:flutter/material.dart';

final List<Color> chipColors = [
  const Color(0xFFE57373), // đỏ
  const Color.fromARGB(255, 15, 96, 163), // xanh dương
  const Color(0xFF81C784), // xanh lá
  const Color.fromARGB(255, 183, 117, 17), // cam
  const Color(0xFFBA68C8), // tím
];

Color getRandomColorWithOpacity() {
  final random = Random();
  return chipColors[random.nextInt(chipColors.length)].withOpacity(0.25); // 👈 nền mờ 25%
}

Widget buildChip(String t) {
  return Chip(
    label: Text(
      t,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF1E1E2D), // chữ đậm rõ hơn
      ),
    ),
    backgroundColor: getRandomColorWithOpacity(), // 👈 màu nền trong suốt
    side: BorderSide.none, // 👈 bỏ đường viền
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0), // 👈 gọn hơn
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: VisualDensity.compact, // 👈 giảm không gian thừa
  );
}

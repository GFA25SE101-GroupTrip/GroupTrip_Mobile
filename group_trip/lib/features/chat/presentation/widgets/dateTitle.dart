  import 'package:flutter/material.dart';

class DateTitle extends StatelessWidget {
  final String text;
  const DateTitle({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
  
  }
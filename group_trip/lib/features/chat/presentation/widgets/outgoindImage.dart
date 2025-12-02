import 'dart:io';

import 'package:flutter/material.dart';

class OutgoingImage extends StatelessWidget {
  final String filePath;
  final String? time;
  const OutgoingImage({super.key, required this.filePath,  this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=me")),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(File(filePath), width: 180)),
              const SizedBox(height: 4),
              if (time != null) Text(time!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
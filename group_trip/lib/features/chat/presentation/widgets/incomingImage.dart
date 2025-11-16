import 'package:flutter/material.dart';

class IncomingImage extends StatelessWidget {
  final String name; 
  final String imageUrl;
  final String? time;

  const IncomingImage({super.key, required this.name, required this.imageUrl, this.time});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=$name")),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(imageUrl, width: 180),
              ),
              const SizedBox(height: 4),
              if (time != null) Text(time!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}
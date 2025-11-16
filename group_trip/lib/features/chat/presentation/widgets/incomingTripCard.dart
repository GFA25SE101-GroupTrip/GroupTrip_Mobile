  
  import 'package:flutter/material.dart';

class IncomingTripCard extends StatelessWidget {
    final String name;
    final String? time;
    
  const IncomingTripCard({super.key, required this.name, this.time});
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Container(
                width: 160,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Trip to Đà Lạt", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("3 ngày · 2 đêm"),
                    SizedBox(height: 12),
                    Text("Xem chi tiết trip →",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              const SizedBox(height: 4),
              if (time != null) Text(time!, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  }
 
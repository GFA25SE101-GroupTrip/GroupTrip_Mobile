import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/data/trip_rule.dart';

class PolicySection extends StatelessWidget {
  final TripRule trip;
  const PolicySection({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> policyData = [
      {
        "title": "Giới hạn độ tuổi",
        "icon": Icons.person,
        "items": [
          "Từ ${trip.minAge} đến ${trip.maxAge} tuổi",
        ],
      },
      {
        "title": "Trình độ kinh nghiệm yêu cầu",
        "icon": Icons.workspace_premium,
        "items": [
          trip.experienceLevel.isNotEmpty
              ? trip.experienceLevel
              : "Không yêu cầu kinh nghiệm",
        ],
      },
      {
        "title": "Ghi chú đặc biệt",
        "icon": Icons.info,
        "items": [
          trip.specialNote.isNotEmpty
              ? trip.specialNote
              : "Không có ghi chú đặc biệt",
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chính sách & Quy định',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
        const SizedBox(height: 16),

        ...policyData.map((section) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      section['icon'],
                      size: 20,
                      color: const Color(0xFF007AFF),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      section['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF1C1C1E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  (section['items'] as List<String>).length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.circle_rounded,
                            size: 16,
                            color: Color(0xFF007AFF),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            section['items'][i],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF3A3A3C),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

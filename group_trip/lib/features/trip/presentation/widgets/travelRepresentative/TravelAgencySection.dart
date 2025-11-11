import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TravelAgency {
  final String name;
  final String imageUrl;

  TravelAgency({required this.name, required this.imageUrl});
}

class TravelAgencySection extends StatelessWidget {
  final List<TravelAgency> agencies = [
    TravelAgency(
      name: 'Vietravel',
      imageUrl: 'https://picsum.photos/seed/1/800/400',
    ),
    TravelAgency(
      name: 'Saigontourist',
      imageUrl: 'https://picsum.photos/seed/2/800/400',
    ),
    TravelAgency(
      name: 'TST Tourist',
      imageUrl: 'https://picsum.photos/seed/3/800/400',
    ),
    TravelAgency(
      name: 'Fiditour',
      imageUrl: 'https://picsum.photos/seed/4/800/400',
    ),
    TravelAgency(
      name: 'BestPrice Travel',
      imageUrl: 'https://picsum.photos/seed/5/800/400',
    ),
  ];

  TravelAgencySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Đơn vị tổ chức nổi bật',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/representative');
                },
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent, // 👈 cho nổi bật
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: agencies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final agency = agencies[index];
              return Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(agency.imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 80,
                    child: Text(
                      agency.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

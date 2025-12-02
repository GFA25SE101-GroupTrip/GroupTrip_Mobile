import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/account/representative/providers/rep_provider.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';

class TravelAgency {
  final String name;
  final String imageUrl;

  TravelAgency({required this.name, required this.imageUrl});
}

class TravelAgencySection extends ConsumerWidget {
  const TravelAgencySection({super.key});

  static const _placeholder = 'https://via.placeholder.com/150?text=No+Image';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repsAsync = ref.watch(repListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Đơn vị tổ chức nổi bật',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // 'Xem thêm' handled below to avoid rebuild issues
            ],
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.push('/representative'),
              child: const Text('Xem thêm', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 14)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: repsAsync.when(
            loading: () => ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[100],
                    ),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(width: 80, child: Container(height: 12, color: Colors.grey[200])),
                ],
              ),
            ),
            error: (_, __) => Center(child: Text('Lỗi khi tải danh sách')), 
            data: (reps) {
              // only show representatives with status == 'accepted'
              final accepted = reps.where((r) => (r.status ?? '').toLowerCase() == 'accepted').toList();
              if (accepted.isEmpty) return const Center(child: Text('Chưa có đơn vị tổ chức'));
              final show = accepted.take(5).toList();
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: show.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final RepModel rep = show[index];
                  final img = (rep.socialMedia != null && rep.socialMedia!.isNotEmpty) ? rep.socialMedia! : _placeholder;
                  final displayName = (rep.contactName == null || rep.contactName!.trim().isEmpty) ? 'Chưa có tên' : rep.contactName!;

                  return GestureDetector(
                    onTap: () => context.push('/representative/detail', extra: {'id': rep.travelRepresentativeProfileId}),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              img,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 80,
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

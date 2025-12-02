import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/account/representative/providers/rep_provider.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';

class TourListPage extends ConsumerWidget {
  const TourListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repsAsync = ref.watch(repListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn vị tổ chức'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: repsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Lỗi: $err')),
        data: (reps) {
          // Only show representatives with status == 'Accepted'
          final accepted = reps.where((r) => (r.status ?? '').toLowerCase() == 'accepted').toList();
          if (accepted.isEmpty) {
            return const Center(child: Text('Không có đơn vị tổ chức được chấp nhận'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: accepted.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final RepModel rep = accepted[index];

              // Provide safe fallbacks for nullable fields
              final displayName =
                  (rep.contactName == null || rep.contactName!.trim().isEmpty)
                      ? 'Chưa cập nhật tên liên hệ'
                      : rep.contactName!;
              final description =
                  (rep.description == null || rep.description!.trim().isEmpty)
                      ? 'Chưa có mô tả'
                      : rep.description!;
              // we no longer display hotline/address/website separately
              final totalTours = rep.totalTours ?? 0;
              final totalCustomers = rep.totalCustomers ?? 0;
              final rating = rep.rating ?? 0.0;

              // leading avatar handled by the left image section (full-bleed)

              return InkWell(
                onTap: () {
                  context.push(
                    '/representative/detail',
                    extra: {'id': rep.travelRepresentativeProfileId},
                  );
                },
                borderRadius: BorderRadius.circular(18),
                splashColor: Colors.blue.withOpacity(0.05),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Image section ---
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                        child: Image.network(
                          rep.socialMedia ?? 'https://via.placeholder.com/120',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[100],
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                        ),
                      ),

                      // --- Info section ---
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name + rating
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.orange,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Icon(
                                    Icons.tour,
                                    size: 16,
                                    color: Colors.blue.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Tours: $totalTours',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(
                                    Icons.group,
                                    size: 16,
                                    color: Colors.green.shade400,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$totalCustomers khách',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget filterButton(String text, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
          side: BorderSide(
            color: selected ? Colors.blue : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // _InfoChip removed — not used in current layout
}

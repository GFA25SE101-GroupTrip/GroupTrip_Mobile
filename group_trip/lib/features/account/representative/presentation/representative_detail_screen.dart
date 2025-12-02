import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/account/representative/presentation/widgets/service_chip.dart';
import 'package:group_trip/features/account/representative/providers/rep_provider.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';
// trip types not needed directly here
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';

class RepresentativeDetail extends ConsumerWidget {
  final String? id;

  const RepresentativeDetail({super.key, this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final repsAsync = ref.watch(repListProvider);
    // colors similar to Traveloka style
    final primary = Colors.blue.shade700;
    final accentBg = Colors.blue.shade50;
    return repsAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (e, st) => Scaffold(
            appBar: AppBar(
              title: const Text('Chi tiết đơn vị'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            body: Center(child: Text('Lỗi khi tải dữ liệu: $e')),
          ),
      data: (reps) {
        // find rep by id if provided, otherwise show first
        RepModel? rep;
        if (id != null) {
          try {
            rep = reps.firstWhere((r) => r.travelRepresentativeProfileId == id);
          } catch (_) {
            rep = null;
          }
        }
        rep ??= reps.isNotEmpty ? reps.first : null;

        if (rep == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Chi tiết đơn vị'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            body: const Center(
              child: Text('Không tìm thấy thông tin đại diện'),
            ),
          );
        }

    // rep is non-null beyond this point
    final repNonNull = rep;

    final avatarUrl = (repNonNull.socialMedia != null && repNonNull.socialMedia!.isNotEmpty)
        ? repNonNull.socialMedia!
        : null;

    // safe rep id to use for chat/contact checks
  final repIdForContact = repNonNull.userId.isNotEmpty
    ? repNonNull.userId
    : (repNonNull.travelRepresentativeProfileId ?? '');

    final contactExistsAsync = ref.watch(checkContactExistsProvider(repIdForContact));
    final contactExists = contactExistsAsync.maybeWhen(data: (v) => v, orElse: () => false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn vị tổ chức'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: avatar + name + rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // avatar with border & shadow
                      Material(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 72,
                            height: 72,
                            color: accentBg,
                            child:
                                avatarUrl != null
                                    ? Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) => Icon(
                                            Icons.image_not_supported,
                                            color: primary,
                                            size: 36,
                                          ),
                                    )
                                    : Icon(
                                      Icons.apartment,
                                      color: primary,
                                      size: 36,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rep.contactName ?? 'contract name',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(
                                    (rep.rating ?? 0).floor(),
                                    (_) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                  )..addAll(
                                    ((rep.rating ?? 0) -
                                                (rep.rating ?? 0).floor() >=
                                            0.5)
                                        ? [
                                          const Icon(
                                            Icons.star_half,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                        ]
                                        : [],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(rep.rating ?? 0).toStringAsFixed(1)} (${rep.totalCustomers ?? 0} đánh giá)',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildStatItem('${rep.totalTours ?? 0}', 'Chuyến đi'),
                        _dividerVert(),
                        _buildStatItem(
                          '${rep.totalCustomers ?? 0}',
                          'Khách hàng',
                        ),
                        _dividerVert(),
                       
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contact buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (contactExists) {
                              // open chat screen
                              context.push('/chat');
                            } else {
                              // no contact yet — start contact flow (placeholder)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bắt đầu liên hệ...')),
                              );
                              // optionally navigate to chat screen to initialize conversation
                              context.push('/chat');
                            }
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: Text(contactExists ? 'Tin nhắn' : 'Liên hệ'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 10),
                      if (repNonNull.websiteUrl.isNotEmpty)
                        OutlinedButton.icon(
                          onPressed: () async {
                            final website = repNonNull.websiteUrl;

                            if (website.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Website không hợp lệ'),
                                ),
                              );
                              return;
                            }

                            final url = Uri.parse(website);

                            if (await canLaunchUrl(url)) {
                              await launchUrl(
                                url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Không thể mở website'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.language, size: 18),
                          label: const Text('Website'),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rep.description ?? 'Chưa có mô tả',
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 12),

                  // Optional contact info
                  if ((rep.address ?? '').isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(rep.address!)),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],
                  if ((rep.hotline ?? '').isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 8),
                        Text(rep.hotline!),
                      ],
                    ),
                    const SizedBox(height: 6),
                  ],

                  const SizedBox(height: 20),

                  // Services placeholder
                  const Text(
                    'Dịch vụ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ServiceChip(
                        icon: Icons.public,
                        label: 'Du lịch quốc tế',
                        bg: accentBg,
                        color: primary,
                      ),
                      ServiceChip(
                        icon: Icons.local_florist,
                        label: 'Du lịch trong nước',
                        bg: accentBg,
                        color: primary,
                      ),
                      ServiceChip(
                        icon: Icons.hotel,
                        label: 'Đặt khách sạn',
                        bg: accentBg,
                        color: primary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Tours (loaded by representative)
                  const Text(
                    'Tours nổi bật',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Builder(builder: (context) {
                    // repNonNull was declared above after the null-check
                    final repIdForFetch = repNonNull.userId.isNotEmpty ? repNonNull.userId : repNonNull.travelRepresentativeProfileId;
                    final tripsAsync = ref.watch(repTripsProvider(repIdForFetch));

                    return tripsAsync.when(
                      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                      error: (e, st) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Lỗi khi tải tours: $e'),
                      ),
                      data: (trips) {
                        if (trips.isEmpty) return const Text('Chưa có tours');

                        final preview = trips.take(3).toList();
                        return SizedBox(
                          height: 250,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: preview.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (_, idx) {
                              final t = preview[idx];
                              final imageUrl = t.tripImages.isNotEmpty ? t.tripImages.first.imgUrl : 'https://via.placeholder.com/400x200';
                              final price = (t.tripDepartures.isNotEmpty && t.tripDepartures.first.tripCostRanges.isNotEmpty)
                                  ? '${t.tripDepartures.first.tripCostRanges.first.price?.toStringAsFixed(0) ?? '-'}đ'
                                  : '-';

                              return Container(
                                width: 240,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(imageUrl, height: 78, width: 240, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 78, color: Colors.grey.shade200)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(t.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 6),
                                          Text('${t.fromDestination} → ${t.finalDestination}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                          const SizedBox(height: 6),
                                          Text(price, style: const TextStyle(color: Color(0xFF007AFF), fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _dividerVert() {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey.shade200,
    );
  }

  
}

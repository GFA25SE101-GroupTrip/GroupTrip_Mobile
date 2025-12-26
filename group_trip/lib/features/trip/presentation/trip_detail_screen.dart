import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/trip/data/trip_rel_model.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/trip_detail_body.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';

class TripDetailPage extends ConsumerStatefulWidget {
  static const routeName = '/trip_detail';
  final String imageUrl;
  final String title;
  final String price;
  final String description;
  final String duration;
  final String peopleRange;
  final String? tripId;
  final TripModel? trip;

  const TripDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
    required this.duration,
    required this.peopleRange,
    this.tripId,
    this.trip,
  });

  @override
  ConsumerState<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends ConsumerState<TripDetailPage> {
  String _formatPrice(dynamic price) {
    final priceStr = price.toString();
    final priceNum = int.tryParse(priceStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final formatted = priceNum.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => '.',
    );
    return '$formatted VND';
  }

  @override
  Widget build(BuildContext context) {
    // If tripId is provided, load full trip details from provider; otherwise use passed props.
    if (widget.tripId != null && widget.tripId!.isNotEmpty) {
      final tripAsync = ref.watch(TripDetailModelProvider(widget.tripId!));

      return tripAsync.when(
        loading: () => Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, st) => Scaffold(
          body: Center(child: Text('Lỗi khi tải chi tiết chuyến đi: $e')),
        ),
        data: (trip) {

          final imageUrl = trip.tripImages.isNotEmpty ? trip.tripImages.first.imgUrl : widget.imageUrl;
          final title = trip.name;
          String price = widget.price;
          String duration = widget.duration;
          String peopleRange = widget.peopleRange;

          if (trip.tripDepartures.isNotEmpty) {
            final d = trip.tripDepartures.first;
            if (d.tripCostRanges.isNotEmpty) {
              final p = d.tripCostRanges.first.price;
              price = 'Từ ${_formatPrice(p)}';
            }
            try {
              final sd = d.startDate;
              duration = '${d.endDate.difference(sd).inDays} ngày';
              duration = duration.isEmpty ? widget.duration : duration;
            } catch (_) {}
            peopleRange = '${trip.minUsers}-${trip.maxUsers} người';
          }

          return Scaffold(
            body: Stack(
              children: [
                SizedBox(height: 320, width: double.infinity, child: Image.network(imageUrl, fit: BoxFit.cover)),
                TripDetailBody(
                  tripId: widget.tripId!,
                  title: title,
                  price: price,
                  description: trip.description,
                  duration: duration,
                  peopleRange: peopleRange,
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.favorite_border, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // fallback: use passed-in values
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: 320, width: double.infinity, child: Image.network(widget.imageUrl, fit: BoxFit.cover)),
          TripDetailBody(
            tripId: widget.tripId!,
            title: widget.title,
            price: widget.price,
            description: widget.description,
            duration: widget.duration,
            peopleRange: widget.peopleRange,
          ),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

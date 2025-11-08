import 'package:flutter/material.dart';
import 'package:group_trip/features/trip/presentation/widgets/trip_items/trip_detail_body.dart';

class TripDetailPage extends StatefulWidget {
  static const routeName = '/trip_detail';
  final String imageUrl;
  final String title;
  final String price;
  final String description;
  final String duration;
  final String peopleRange;

  const TripDetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.description,
    required this.duration,
    required this.peopleRange,
  });

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 320,
            width: double.infinity,
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),

          TripDetailBody(
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
                  onTap: () {
                    Navigator.pop(context);
                  },
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

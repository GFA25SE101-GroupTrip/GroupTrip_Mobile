import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/staff/data/staff_data.dart';
import 'package:group_trip/features/staff/presentation/widgets/trip_tracking_helpers.dart';

class TripHeaderInfo extends StatelessWidget {
  final DepartureStaff trip;
  final DateFormat dateFormat;

  const TripHeaderInfo({
    super.key,
    required this.trip,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Full-width scenic hero image at the top
        ClipRRect(
          borderRadius: BorderRadius.zero,
          child: Container(
            width: double.infinity,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
            ),
            child: trip.tripImages.isNotEmpty
                ? Image.network(
                  trip.tripImages.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                )
                : Container(
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
          ),
        ),
        // Professional back button
        Positioned(
          top: 12,
          left: 12,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        // Soft rounded white bottom card overlay with subtle shadow
        Positioned(
          top: 220,
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bold tour title with visual hierarchy
                    Text(
                      trip.tripName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 24,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: TrackingPhaseHelper.getStatusColor(
                          trip.departureStatus,
                        ).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: TrackingPhaseHelper.getStatusColor(
                            trip.departureStatus,
                          ).withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        TrackingPhaseHelper.getStatusLabel(trip.departureStatus),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: TrackingPhaseHelper.getStatusColor(
                            trip.departureStatus,
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Icon-based metadata row for duration and group size
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: Color(0xFF007AFF),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${dateFormat.format(DateTime.parse(trip.startDate))} - ${dateFormat.format(DateTime.parse(trip.endDate))}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.people_outline,
                            size: 20,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${trip.numberMemberIn} người tham gia',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Large full-width primary blue CTA button with rounded corners
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Liên hệ nhóm ${trip.tripName}'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone, size: 20),
                        label: const Text(
                          'Liên hệ nhóm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

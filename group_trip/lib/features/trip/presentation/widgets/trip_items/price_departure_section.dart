import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:group_trip/features/trip/presentation/widgets/process/joinTripPaymentSheet.dart';
import 'package:group_trip/features/wallet/providers/wallet_provider.dart';
import 'package:intl/intl.dart';
import 'package:group_trip/features/trip/data/trip_departure_model.dart';
import 'package:group_trip/features/trip/data/trip_cost_range_model.dart';
import 'package:group_trip/features/trip/providers/tripProvider.dart';

class PriceDepartureSection extends ConsumerWidget {
  final List<TripDeparture> tripDepartures;
  final String tripImage;
  final String tripTitle;
  final String? selectedInsuranceId;

  const PriceDepartureSection({
    super.key,
    required this.tripDepartures,
    required this.tripImage,
    required this.tripTitle,
    this.selectedInsuranceId,
  });

  String _formatDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('dd/MM/yyyy');
    return "${formatter.format(start)} - ${formatter.format(end)}";
  }

  String _formatWeekdayRange(DateTime start, DateTime end) {
    final weekday = [
      "Chủ nhật",
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
    ];
    return "${weekday[start.weekday % 7]} - ${weekday[end.weekday % 7]}";
  }

  String _formatCurrency(num? price) {
    if (price == null) return '';
    final formatter = NumberFormat("#,###", "vi_VN");
    return "${formatter.format(price)}đ";
  }

  Future<void> _onSelectDeparture(
    BuildContext context,
    WidgetRef ref,
    TripDeparture departure,
    int intBalance,
    String? selectedInsuranceId,
  ) async {
    if (departure.tripCostRanges.isEmpty) return;

    final minRange = departure.tripCostRanges.reduce(
      (a, b) => a.price < b.price ? a : b,
    );

    try {
      final repo = ref.read(tripRepositoryProvider);
      print('Attempting to join trip departure: ${departure.id}');
      print('Selected Insurance ID: $selectedInsuranceId');
      // Gọi joinTrip trước
      final result = await repo.joinTrip(departure.id);
      if (result['success'] == true) {
        // Nếu join thành công và có bảo hiểm được chọn, thêm bảo hiểm
        if (selectedInsuranceId != null && selectedInsuranceId.isNotEmpty) {
          await repo.addInsuranceToTripDeparture(departure.id, selectedInsuranceId);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tham gia chuyến đi thành công')),
        );
        final _refWallet = ref.refresh(walletModelProvider);
        _refWallet.whenOrNull(data: (_) {});
        final _refTrip = ref.refresh(TripModelProvider);
        _refTrip.whenOrNull(data: (_) {});
      } else {
        final errorMessage = result['errorMessage'] ?? 'Tham gia thất bại';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }

    print('minPrice: ${minRange.price} - User Balance: $intBalance');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletModelProvider);
    final ballance = wallet.asData?.value?.balance ?? 0;
    // parse ballance từ double sang int
    final intBalance = ballance.toInt();
    if (tripDepartures.isEmpty) {
      return const Center(
        child: Text("Chưa có lịch khởi hành nào được công bố."),
      );
    }

    return Column(
      key: const ValueKey('price_departure'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...tripDepartures
            .where((departure) => departure.departureStatus?.toLowerCase() == 'ready')
            .map((departure) {
          final dateText = _formatDateRange(
            departure.startDate,
            departure.endDate,
          );
          final weekdayText = _formatWeekdayRange(
            departure.startDate,
            departure.endDate,
          );
          final memberCount = departure.tripMembers.length;
          final costRanges = departure.tripCostRanges;
          
          // Watch checkJoin status for this specific departure
          final checkJoinStatus = ref.watch(CheckJoinTripProvider(departure.id));
          final checkJoin = checkJoinStatus.asData?.value ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dòng 1: Ngày + số người tham gia
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "$memberCount người tham gia",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),
                // Dòng 2: Thứ
                Text(
                  weekdayText,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),

                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 10),

                // Danh sách cost ranges (nhiều loại giá)
                if (costRanges.isEmpty)
                  const Text(
                    "Chưa cập nhật giá.",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        costRanges.map((range) {
                          final priceText = _formatCurrency(range.price);
                          final peopleRangeText =
                              "Từ ${range.minTraveller} - ${range.maxTraveller} người";

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  peopleRangeText,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  priceText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF007AFF),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: checkJoin
                      ? OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF22C55E),
                            ),
                          ),
                          onPressed: null,
                          child: const Text(
                            "Bạn đã tham gia",
                            style: TextStyle(
                              color: Color(0xFF22C55E),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFF007AFF)),
                          ),
                          onPressed: () =>
                              _onSelectDeparture(context, ref, departure, intBalance, selectedInsuranceId),
                          child: const Text(
                            "Chọn ngày này",
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

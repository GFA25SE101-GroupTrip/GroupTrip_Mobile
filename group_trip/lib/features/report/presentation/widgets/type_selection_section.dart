import 'package:flutter/material.dart';
import 'package:group_trip/features/report/presentation/widgets/buildDropdown.dart';

class TypeSelectionSection extends StatelessWidget {
  final String selectedContact;
  final String? selectedType;
  final String? selectedTrip;
  final List<String> adminTypes;
  final List<String> representativeTypes;
  final List<String> tripNames;
  final Function(String?) onTypeChanged;
  final Function(String?) onTripChanged;

  const TypeSelectionSection({
    Key? key,
    required this.selectedContact,
    required this.selectedType,
    required this.selectedTrip,
    required this.adminTypes,
    required this.representativeTypes,
    required this.tripNames,
    required this.onTypeChanged,
    required this.onTripChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedContact == 'Admin') ...[
          const Text('Loại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Builddropdown<String>(
            hint: 'Chọn loại...',
            value: selectedType,
            items: adminTypes,
            onChanged: onTypeChanged,
          ),
        ] else if (selectedContact == 'TravelRepresentative') ...[
          const Text('Chuyến đi tham gia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Builddropdown<String>(
            hint: 'Chọn chuyến đi...',
            value: selectedTrip,
            items: tripNames,
            onChanged: onTripChanged,
          ),
          const SizedBox(height: 16),
          const Text('Loại', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Builddropdown<String>(
            hint: 'Chọn loại...',
            value: selectedType,
            items: representativeTypes,
            onChanged: onTypeChanged,
          ),
        ],
        const SizedBox(height: 18),
      ],
    );
  }
}

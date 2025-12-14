import 'package:flutter/material.dart';
import 'package:group_trip/features/report/presentation/widgets/buildContract.dart';

class ContactSelectionSection extends StatelessWidget {
  final String selectedContact;
  final Function(String) onAdminTap;
  final Function(String) onRepresentativeTap;

  const ContactSelectionSection({
    Key? key,
    required this.selectedContact,
    required this.onAdminTap,
    required this.onRepresentativeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bạn muốn liên hệ với ai?',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        const SizedBox(height: 10),
        // Option: Admin
        Buildcontract(
          title: 'Admin',
          subtitle: 'Hệ thống / Vấn đề thanh toán',
          icon: Icons.admin_panel_settings_rounded,
          selected: selectedContact == 'Admin',
          onTap: () => onAdminTap('Admin'),
          selectedContact: selectedContact,
        ),
        const SizedBox(height: 12),
        // Option: Travel Representative
        Buildcontract(
          title: 'Đại diện du lịch',
          subtitle: 'Vấn đề về chuyến đi',
          icon: Icons.card_travel_rounded,
          selected: selectedContact == 'TravelRepresentative',
          onTap: () => onRepresentativeTap('TravelRepresentative'),
          selectedContact: selectedContact,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

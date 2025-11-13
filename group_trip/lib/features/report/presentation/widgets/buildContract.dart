import 'package:flutter/material.dart';

class Buildcontract extends StatelessWidget {
    final  String title;
    final String subtitle;
    final IconData icon;
    final bool selected;
    final VoidCallback onTap;
    final String? selectedContact;
  const Buildcontract({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.selectedContact,
  });

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? Colors.blue : Colors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: selected ? Colors.blue : Colors.black)),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Radio<String>(
              value: title == 'Admin' ? 'Admin' : 'Representative',
              groupValue: selectedContact,
              onChanged: (_) => onTap(),
              activeColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

}
import 'package:flutter/material.dart';

class DropdownFilter extends StatefulWidget {
  const DropdownFilter({super.key});

  @override
  State<DropdownFilter> createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  final List<String> _categories = [
    'Tất cả',
    'Phiêu lưu',
    'Văn hóa',
    'Nghỉ dưỡng',
  ];
  String selectedCategory = 'Tất cả';

  String? destination;
  String? price;
  String? time;
  String? topic;
  String? organizer;

  final List<String> vietnamProvinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth.isFinite
                  ? constraints.maxWidth
                  : MediaQuery.of(context).size.width;
              const double spacing = 12;

              final double halfWidth = ((maxWidth - spacing) / 2).clamp(
                0,
                double.infinity,
              );
              final double fullWidth = maxWidth.clamp(0, double.infinity);

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  _buildDropdown(
                    'Điểm đến',
                    vietnamProvinces,
                    destination,
                    (val) => setState(() => destination = val),
                    width: halfWidth,
                  ),
                  _buildDropdown(
                    'Giá từ',
                    ['< 1tr', '1-3tr', '3-5tr', '> 5tr'],
                    price,
                    (val) => setState(() => price = val),
                    width: halfWidth,
                  ),
                  _buildDropdown(
                    'Thời gian',
                    ['1 ngày', '2-3 ngày', 'Tuần'],
                    time,
                    (val) => setState(() => time = val),
                    width: halfWidth,
                  ),
                  _buildDropdown(
                    'Chủ đề',
                    ['Team building', 'Honeymoon', 'Phượt'],
                    topic,
                    (val) => setState(() => topic = val),
                    width: halfWidth,
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: _buildDropdown(
                      'Đơn vị tổ chức',
                      ['Vietravel', 'Saigontourist', 'TST Tourist', 'Fiditour'],
                      organizer,
                      (val) => setState(() => organizer = val),
                      width: fullWidth,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final bool isSelected = category == selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => selectedCategory = category),
                  selectedColor: const Color(0xFF007AFF),
                  backgroundColor: Colors.white,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF007AFF)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged, {
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: value,
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
      ),
    );
  }
}

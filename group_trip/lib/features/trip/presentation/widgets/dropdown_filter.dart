import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DropdownFilter extends StatefulWidget {
  final Function(DateTime?)? onDateSelected;
  const DropdownFilter({super.key, this.onDateSelected});

  @override
  State<DropdownFilter> createState() => _DropdownFilterState();
}

class _DropdownFilterState extends State<DropdownFilter> {
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () => _selectDate(context),
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Chọn ngày tìm kiếm',
                filled: true,
                fillColor: colorScheme.surfaceContainer,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.outlineVariant),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today_rounded,
                  color: colorScheme.primary,
                ),
              ),
              child: Text(
                _selectedDate != null
                    ? DateFormat('dd/MM/yyyy', 'vi_VN').format(_selectedDate!)
                    : 'Chọn ngày tìm kiếm',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: _selectedDate != null
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        if (_selectedDate != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Call callback with selected date
                widget.onDateSelected?.call(_selectedDate);
                debugPrint('Searching for trips on ${DateFormat('dd/MM/yyyy', 'vi_VN').format(_selectedDate!)}');
              },
              child: const Text(
                'Tìm kiếm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ],
    );
  }
}


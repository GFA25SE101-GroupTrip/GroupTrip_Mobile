import 'package:flutter/material.dart';

class Builddropdown<T> extends StatelessWidget {
  final  String hint;
  final  T? value;
   final  List<T> items;
    final ValueChanged<T?> onChanged;

  const Builddropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      hint: Text(hint),
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(e.toString()),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

}
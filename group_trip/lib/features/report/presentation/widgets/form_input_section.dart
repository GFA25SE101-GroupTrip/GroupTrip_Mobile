import 'package:flutter/material.dart';

class FormInputSection extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController descriptionController;

  const FormInputSection({
    Key? key,
    required this.subjectController,
    required this.descriptionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Subject
        TextField(
          controller: subjectController,
          decoration: const InputDecoration(
            labelText: 'Tiêu đề',
            hintText: 'Ví dụ: Yêu cầu hoàn tiền cho trip Đà Lạt',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 16),
          maxLength: 100,
        ),
        const SizedBox(height: 14),
        // Description
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Mô tả',
            hintText: 'Vui lòng mô tả chi tiết vấn đề bạn gặp phải...',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(fontSize: 15),
          maxLines: 6,
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

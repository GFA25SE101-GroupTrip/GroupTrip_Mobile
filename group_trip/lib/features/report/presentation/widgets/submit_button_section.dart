import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/report/data/create_report_model.dart';
import 'package:group_trip/features/report/providers/report_provider.dart';
import 'package:image_picker/image_picker.dart';

class SubmitButtonSection extends ConsumerWidget {
  final String selectedContact;
  final String? selectedType;
  final String? selectedTrip;
  final TextEditingController subjectController;
  final TextEditingController descriptionController;
  final XFile? attachedImage;
  final File? attachedFile;
  final Function(String) getTypeValue;
  final Function() onSuccess;

  const SubmitButtonSection({
    Key? key,
    required this.selectedContact,
    required this.selectedType,
    required this.selectedTrip,
    required this.subjectController,
    required this.descriptionController,
    required this.attachedImage,
    required this.attachedFile,
    required this.getTypeValue,
    required this.onSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          // Validate required fields
          if (selectedContact.isEmpty || selectedType == null || subjectController.text.isEmpty || descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
            );
            return;
          }

          if (selectedContact == 'TravelRepresentative' && selectedTrip == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng chọn chuyến đi')),
            );
            return;
          }

          // Get the actual English values for submission
          final typeValue = getTypeValue(selectedType ?? '');
          
          // Determine assignToRole based on selectedContact
          final assignToRole = selectedContact == 'Admin' ? 'Admin' : 'Representative';
          
          print(
            'Submitting report with: userId\n'
            'Type: $typeValue\n'
            'AssignToRole: $assignToRole\n'
            'TargetId: $selectedTrip\n'
            'Subject: ${subjectController.text}\n'
            'Description: ${descriptionController.text}\n'
            'Attachment: ${attachedFile != null ? attachedFile!.path : 'No attachment'}'
          );
          // Create report model
          final report = CreateReportModel(
            userId: '', // Empty as requested
            targetId: selectedTrip, // Trip ID or null
            assignToRole: assignToRole,
            type: typeValue,
            title: subjectController.text,
            content: descriptionController.text,
            status: 'Pending', // Default status
            attach: attachedImage != null ? [attachedFile!] : null, // Include attachment if exists
          );

          try {
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => const Center(
                child: CircularProgressIndicator(),
              ),
            );

            // Call API
            await ref.read(submitReportProvider(report).future);

            // Dismiss loading and show success message
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đơn yêu cầu đã được gửi thành công!')),
            );

            // Call success callback
            onSuccess();

            // Navigate back
            if (context.mounted) {
              Navigator.pop(context);
            }
          } catch (e) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi: $e')),
            );
          }
        },
        child: const Text('Gửi yêu cầu',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}

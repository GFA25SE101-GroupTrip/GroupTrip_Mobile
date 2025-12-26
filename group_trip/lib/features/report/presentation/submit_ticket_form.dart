import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/report/presentation/widgets/contact_selection_section.dart';
import 'package:group_trip/features/report/presentation/widgets/type_selection_section.dart';
import 'package:group_trip/features/report/presentation/widgets/form_input_section.dart';
import 'package:group_trip/features/report/presentation/widgets/attachment_section.dart';
import 'package:group_trip/features/report/presentation/widgets/submit_button_section.dart';
import 'package:group_trip/features/mytrip/providers/mytrip_provider.dart';
import 'package:group_trip/features/report/presentation/utils/image_picker_helper.dart';
import 'package:image_picker/image_picker.dart';

class SubmitTicketScreen extends ConsumerStatefulWidget {
  const SubmitTicketScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends ConsumerState<SubmitTicketScreen> {
  String selectedContact = '';
  String? selectedType;
  String? selectedTrip;
  String? selectedCategory;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? attachedImage;
  File? attachedFile;

  // Mapping Vietnamese display names to English values
  final Map<String, String> typeMapping = {
    'Hoàn tiền': 'Refund',
    'Khiếu nại': 'Complain',
    'Hỗ trợ': 'Support',
    'Rút tiền': 'WithDraw',
  };

  final List<String> adminTypes = ['Hoàn tiền', 'Khiếu nại', 'Hỗ trợ', 'Rút tiền'];
  final List<String> representativeTypes = ['Hoàn tiền', 'Khiếu nại', 'Hỗ trợ', 'Rút tiền'];

  String _getTypeValue(String? displayName) {
    return displayName != null ? typeMapping[displayName] ?? displayName : '';
  }

  @override
  Widget build(BuildContext context) {
    final myTripsAsync = ref.watch(mytripNotifierProvider);
    
    return myTripsAsync.when(
      data: (trips) {
        // Filter only completed trips
        final completedTrips = trips.where((trip) => trip.departureStatus?.toLowerCase() == 'completed').toList();
        // Create a map: tripId -> tripName for display
        final tripIdToNameMap = {for (var trip in completedTrips) trip.departureId: trip.name};
        final tripIds = completedTrips.map((trip) => trip.departureId).toList();
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Đơn hỗ trợ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Selection Section
                ContactSelectionSection(
                  selectedContact: selectedContact,
                  onAdminTap: (role) {
                    setState(() {
                      selectedContact = role;
                      selectedType = null;
                      selectedTrip = null;
                      attachedImage = null;
                      attachedFile = null;
                    });
                  },
                  onRepresentativeTap: (role) {
                    setState(() {
                      selectedContact = role;
                      selectedType = null;
                      selectedTrip = null;
                      attachedImage = null;
                      attachedFile = null;
                    });
                  },
                ),

                // Type Selection Section
                TypeSelectionSection(
                  selectedContact: selectedContact,
                  selectedType: selectedType,
                  selectedTrip: selectedTrip != null ? tripIdToNameMap[selectedTrip] : null,
                  adminTypes: adminTypes,
                  representativeTypes: representativeTypes,
                  tripNames: tripIds.map((id) => tripIdToNameMap[id] ?? '').toList(),
                  onTypeChanged: (val) {
                    setState(() {
                      selectedType = val;
                    });
                  },
                  onTripChanged: (val) {
                    setState(() {
                      // val is the display name (tripName), find corresponding tripId
                      final tripId = tripIdToNameMap.entries
                          .firstWhere((e) => e.value == val, orElse: () => MapEntry('', ''))
                          .key;
                      selectedTrip = tripId.isNotEmpty ? tripId : null;
                    });
                  },
                ),

                // Form Input Section
                FormInputSection(
                  subjectController: subjectController,
                  descriptionController: descriptionController,
                ),

                // Attachment Section
                AttachmentSection(
                  attachedImage: attachedImage,
                  attachedFile: attachedFile,
                  onTap: _showAttachmentOptions,
                  onDelete: () {
                    setState(() {
                      attachedImage = null;
                      attachedFile = null;
                    });
                  },
                ),

                // Submit Button Section
                SubmitButtonSection(
                  selectedContact: selectedContact,
                  selectedType: selectedType,
                  selectedTrip: selectedTrip,
                  subjectController: subjectController,
                  descriptionController: descriptionController,
                  attachedImage: attachedImage,
                  attachedFile: attachedFile,
                  getTypeValue: _getTypeValue,
                  onSuccess: () {
                    setState(() {
                      selectedContact = '';
                      selectedType = null;
                      selectedTrip = null;
                      subjectController.clear();
                      descriptionController.clear();
                      attachedImage = null;
                      attachedFile = null;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Đơn hỗ trợ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Đơn hỗ trợ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Text('Lỗi: $error'),
        ),
      ),
    );
  }



  Future<void> _showAttachmentOptions() async {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn ảnh từ thư viện'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp ảnh'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Hủy'),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await ImagePickerHelper.pickImage(source);
      if (file == null) return;

      final f = File(file.path);
      final bytes = await f.length();
      const maxBytes = 10 * 1024 * 1024; // 10MB
      if (bytes > maxBytes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tệp quá lớn. Vui lòng chọn ảnh < 10MB.')),
        );
        return;
      }

      setState(() {
        attachedImage = file;
        attachedFile = f;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải ảnh: $e')),
      );
    }
  }
}

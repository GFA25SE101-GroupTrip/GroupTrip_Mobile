import 'dart:io';
import 'package:flutter/material.dart';
import 'package:group_trip/core/utils/dataFormat.dart';
import 'package:image_picker/image_picker.dart';

class AttachmentSection extends StatelessWidget {
  final XFile? attachedImage;
  final File? attachedFile;
  final Function() onTap;
  final Function() onDelete;

  const AttachmentSection({
    Key? key,
    required this.attachedImage,
    required this.attachedFile,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Attachment box (image only)
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey.shade50,
            ),
            child: attachedImage == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cloud_upload_outlined,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Chạm để tải ảnh lên hoặc chụp ảnh',
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                        SizedBox(height: 6),
                        Text('Kích thước tối đa: 10MB',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(attachedImage!.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              attachedImage!.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              FormatFileSize(attachedFile),
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.close, color: Colors.grey),
                      )
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }
}

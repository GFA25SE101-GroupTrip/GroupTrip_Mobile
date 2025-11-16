import 'dart:io';
import 'package:dio/dio.dart';

class CreateReportModel {
  final String targetId;
  final String assignToRole;
  final String type;
  final String title;
  final String content;
  final String status;

  /// List<File> cho ảnh hoặc file đính kèm
  final List<File>? attach;

  /// List<File> cho file PDF
  final List<File>? pdfFile;

  CreateReportModel({
    required this.targetId,
    required this.assignToRole,
    required this.type,
    required this.title,
    required this.content,
    required this.status,
    this.attach,
    this.pdfFile,
  });

  /// Convert model thành FormData (multipart/form-data)
  Future<FormData> toFormData() async {
    final formData = FormData();

    // Các field dạng string
    formData.fields.add(MapEntry("TargetId", targetId));
    formData.fields.add(MapEntry("AssignToRole", assignToRole));
    formData.fields.add(MapEntry("Type", type));
    formData.fields.add(MapEntry("Title", title));
    formData.fields.add(MapEntry("Content", content));
    formData.fields.add(MapEntry("Status", status));

    // Attach[]
    if (attach != null) {
      for (final file in attach!) {
        formData.files.add(
          MapEntry(
            "Attach",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split("/").last,
            ),
          ),
        );
      }
    }

    // PdfFile[]
    if (pdfFile != null) {
      for (final file in pdfFile!) {
        formData.files.add(
          MapEntry(
            "PdfFile",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split("/").last,
            ),
          ),
        );
      }
    }

    return formData;
  }
}

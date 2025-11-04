import 'package:dio/dio.dart';
import 'dart:io';

import 'package:group_trip/core/api/api_client.dart';

class UploadImageService {
  Future<String> uploadImage(File imageFile) async {
    final api = ApiClient.fromEnv();

    // 🔹 Chuẩn bị FormData
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    // 🔹 Gửi request
    final response = await api.post(
      'user',
      '/api/images',
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data as String;
    }

    return '';
  }
}

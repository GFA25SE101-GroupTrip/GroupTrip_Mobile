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
    final response = await api.post('user', '/api/images', data: formData);

    if (response.statusCode == 200) {
      return response.data as String;
    }

    return '';
  }

  Future<bool> uploadImageToBlog(File imageFile, String blogId) async {
    final api = ApiClient.fromEnv();
    // 🔹 Chuẩn bị FormData đúng với Swagger
    final formData = FormData.fromMap({
      'listImages': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    });

    print('Uploading image to blog with blogId: $blogId');
    print('FormData contents: ${formData.fields}, ${formData.files}');
    // 🔹 Gửi request có query parameter blogId
    final response = await api.post(
      'user',
      '/api/images/addimagetoblog?blogId=$blogId',
      data: formData,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}

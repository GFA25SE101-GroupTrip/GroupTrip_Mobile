import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/constants/uploadImage.dart';

final uploadImageServiceProvider = Provider<UploadImageService>((ref) {
  return UploadImageService();
});
final imageProvider = StateNotifierProvider.autoDispose<ImageNotifier, AsyncValue<void>>((ref) {
  final uploader = ref.read(uploadImageServiceProvider);
  return ImageNotifier(uploader);
});

class ImageNotifier extends StateNotifier<AsyncValue<void>> {
  final UploadImageService uploadImageToServer;
  ImageNotifier(this.uploadImageToServer) : super(AsyncValue.data(null));

  Future<void> uploadImage(File imageFile, String blogId) async {
    state = const AsyncValue.loading();
    try {
      final uploadResult = await uploadImageToServer.uploadImageToBlog(imageFile, blogId);
      if (uploadResult) {
        state = AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Image upload failed', StackTrace.current);
        return;
      }
    } catch (e) {
      state = AsyncValue.error('Image upload failed', StackTrace.current);
    }
  }
}
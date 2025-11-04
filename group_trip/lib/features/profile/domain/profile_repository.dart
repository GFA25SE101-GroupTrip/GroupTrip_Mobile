
import 'package:group_trip/features/profile/data/profile_api.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<ProfileModel> fetchUserProfile() async {
    try {
      // ignore: avoid_print
      print('🔁 [ProfileRepository] fetchUserProfile()');
      final res = await remoteDataSource.fetchUserProfile();
      // ignore: avoid_print
      print('✅ [ProfileRepository] fetchUserProfile completed');
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [ProfileRepository] fetchUserProfile failed: $e');
      rethrow;
    }
  }
  Future<void> updateUserProfile(String bio, String imageUrl) async {
    try {
      // ignore: avoid_print
      print('🔁 [ProfileRepository] updateUserProfile(bio=${bio}, imageUrl=${imageUrl})');
      await remoteDataSource.updateUserProfile(bio, imageUrl);
      // ignore: avoid_print
      print('✅ [ProfileRepository] updateUserProfile completed');
    } catch (e) {
      // ignore: avoid_print
      print('❌ [ProfileRepository] updateUserProfile failed: $e');
      rethrow;
    }
  }
}
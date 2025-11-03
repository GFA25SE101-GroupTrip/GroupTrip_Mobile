
import 'package:group_trip/features/profile/data/profile_api.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<ProfileModel> fetchUserProfile() async {
    try {
      return await remoteDataSource.fetchUserProfile();
    } catch (e) {
      rethrow;
    }
  }
}
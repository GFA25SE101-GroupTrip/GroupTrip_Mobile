
import 'package:group_trip/features/profile/data/profile_api.dart';
import 'package:group_trip/features/profile/data/profile_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepository({required this.remoteDataSource});

  Future<void> updateUserBio(String userProfileID, String bio, String imageUrl) async {
    try {
      // ignore: avoid_print
      print('🔁 [ProfileRepository] updateUserBio(bio=${bio}, imageUrl=${imageUrl})');
      await remoteDataSource.updateUserBio(userProfileID, bio, imageUrl);
      // ignore: avoid_print
      print('✅ [ProfileRepository] updateUserBio completed');
    } catch (e) {
      // ignore: avoid_print
      print('❌ [ProfileRepository] updateUserBio failed: $e');
      rethrow;
    }
  }

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
  Future<void> updateUserInformation(String userID,
    String fullname,
    String phonenumber,
    String bankAccount,
    String bankName) async {
    try {
      // ignore: avoid_print
      print('🔁 [ProfileRepository] updateUserInformation(name=${fullname}, email=${phonenumber})');
      // Assuming there's a method in remoteDataSource for updating user information
      await remoteDataSource.updateUserInformation(userID, fullname, phonenumber, bankAccount, bankName);
      // ignore: avoid_print
      print('✅ [ProfileRepository] updateUserInformation completed');
    } catch (e) {
      // ignore: avoid_print
      print('❌ [ProfileRepository] updateUserInformation failed: $e');
      rethrow;
    }
  }
}

class UserInformationRespository {
  final ProfileRemoteDataSource remoteDataSource;

  UserInformationRespository({required this.remoteDataSource});

  Future<UserInformation> fetchUserInformation(String userID) async {
    try {
      // ignore: avoid_print
      print('🔁 [UserInformationRespository] fetchUserInformation(userID=${userID})');
      final res = await remoteDataSource.fetchUserInformation(userID);
      // ignore: avoid_print
      print('✅ [UserInformationRespository] fetchUserInformation completed');
      return res;
    } catch (e) {
      // ignore: avoid_print
      print('❌ [UserInformationRespository] fetchUserInformation failed: $e');
      rethrow;
    }
  }
}
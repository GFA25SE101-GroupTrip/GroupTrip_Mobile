import 'package:group_trip/features/account/traveller/data/tral_api.dart';
import 'package:group_trip/features/account/traveller/data/tral_model.dart';

class TravellerRepository {
  // Repository methods would be defined here
  final TravellerResourceData remoteDataSource;
  TravellerRepository({required this.remoteDataSource});
  Future<TravellerModel> fetchUserProfile(String userID) {
    return remoteDataSource.fetchUserProfile(userID);
  }

  Future<List<BlogsTraveller>> fetchTravellerBlogs(String userID) {
  

    return remoteDataSource.fetchBlogsByTraveller(userID);
  }
}
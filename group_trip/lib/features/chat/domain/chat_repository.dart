import 'package:group_trip/features/chat/data/chat_api.dart';

class ChatRepository {
  // Define methods for chat repository
  final ChatRemoteDataSource remoteDataSource;
  ChatRepository({required this.remoteDataSource});
  Future<bool> checkContactExists(String userId) {
    return remoteDataSource.checkContactExists(userId);
  }

}
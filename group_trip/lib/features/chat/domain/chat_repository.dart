import 'package:group_trip/features/chat/data/chat_api.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';

class ChatRepository {
  // Define methods for chat repository
  final ChatRemoteDataSource remoteDataSource;
  ChatRepository({required this.remoteDataSource});
  Future<bool> checkContactExists(String userId) {
    return remoteDataSource.checkContactExists(userId);
  }

  Future<List<ChatModel>> getChatList() {
    return remoteDataSource.getChatList();
  }

  Future<ChatModel> getChatDetail(String chatId) {
    return remoteDataSource.getChatDetail(chatId);
  }

}
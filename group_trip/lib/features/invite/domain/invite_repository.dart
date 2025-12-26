import 'package:group_trip/features/invite/data/inviteData.dart';
import 'package:group_trip/features/invite/data/invite_api.dart';

class InviteRepository {
  final InviteRemoteDataSource remoteDataSource;
  InviteRepository({required this.remoteDataSource});
  Future<List<InvitedData>> getReceivedInvites() async {
    return remoteDataSource.fetchReceivedInvites();
  }
  Future<List<InvitedData>> getSentInvites() async {
    return remoteDataSource.fetchSentInvites();
  }

  Future<void> updateInvitationStatus({
    required String invitationId,
    required String status,
  }) async {
    return remoteDataSource.updateInvitationStatus(
      invitationId: invitationId,
      status: status,
    );
  }

  Future<List<UserSearch>> searchUsers(String query) async {
    return remoteDataSource.fetchUserByEmail(query);
  }

  Future<void> sendInvitation({
    required String toUserId,
    required String tripdepartureId,
    required String content,
  }) async {
    return remoteDataSource.sendInvitation(
      toUserId: toUserId,
      tripdepartureId: tripdepartureId,
      content: content,
    );
  }
}
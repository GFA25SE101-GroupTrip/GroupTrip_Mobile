import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/features/invite/data/inviteData.dart';
import 'package:group_trip/features/invite/data/invite_api.dart';
import 'package:group_trip/features/invite/domain/invite_repository.dart';

final InviteRemoteDataSourceProvider = Provider<InviteRemoteDataSource>((ref) {
  return InviteRemoteDataSource(apiClient: ref.watch(apiClientProvider));
});

final inviteRepositoryProvider = Provider<InviteRepository>((ref) {
  return InviteRepository(
      remoteDataSource: ref.watch(InviteRemoteDataSourceProvider));
});
final receivedInvitesProvider =
    FutureProvider<List<InvitedData>>((ref) async {
  final repository = ref.watch(inviteRepositoryProvider);
  return repository.getReceivedInvites();
});
final sentInvitesProvider =
    FutureProvider<List<InvitedData>>((ref) async {
  final repository = ref.watch(inviteRepositoryProvider);
  return repository.getSentInvites();
});


final updateInvitationStatusProvider =
    FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repository = ref.watch(inviteRepositoryProvider);
  final invitationId = params['invitationId']!;
  final status = params['status']!;
  await repository.updateInvitationStatus(
    invitationId: invitationId,
    status: status,
  );
  // Refetch the invite lists after successful update
  ref.invalidate(receivedInvitesProvider);
  ref.invalidate(sentInvitesProvider);
});

final userSearchProvider =
    FutureProvider.family<List<UserSearch>, String>((ref, query) async {
  final repository = ref.watch(inviteRepositoryProvider);
  return repository.searchUsers(query);
});

final sendInvitationProvider =
    FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repository = ref.watch(inviteRepositoryProvider);
  final toUserId = params['toUserId']!;
  final tripdepartureId = params['tripdepartureId']!;
  final content = params['content']!;
  await repository.sendInvitation(
    toUserId: toUserId,
    tripdepartureId: tripdepartureId,
    content: content,
  );
  // Refetch the invite lists after successful sending
  ref.invalidate(sentInvitesProvider);
});
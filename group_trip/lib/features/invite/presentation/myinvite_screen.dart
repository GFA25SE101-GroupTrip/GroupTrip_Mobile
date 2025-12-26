import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/invite/data/invite_model.dart';
import 'package:group_trip/features/invite/provider/invite_provider.dart';
import 'package:intl/intl.dart';

class MyInviteScreen extends ConsumerStatefulWidget {
  const MyInviteScreen({super.key});

  @override
  ConsumerState<MyInviteScreen> createState() => _MyInviteScreenState();
}

class _MyInviteScreenState extends ConsumerState<MyInviteScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receivedInvitesAsync = ref.watch(receivedInvitesProvider);
    final sentInvitesAsync = ref.watch(sentInvitesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lời mời tham gia',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mail_outline, size: 18),
                  const SizedBox(width: 6),
                  const Text('Đã nhận'),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: receivedInvitesAsync.when(
                      data: (invites) => Text(
                        '${invites.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      loading: () => const Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      error: (_, __) => const Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_outlined, size: 18),
                  const SizedBox(width: 6),
                  const Text('Đã gửi'),
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: sentInvitesAsync.when(
                      data: (invites) => Text(
                        '${invites.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      loading: () => const Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      error: (_, __) => const Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Received invites tab
          receivedInvitesAsync.when(
            data: (invites) => _buildReceivedInvitesTab(invites),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Lỗi: $error')),
          ),
          // Sent invites tab
          sentInvitesAsync.when(
            data: (invites) => _buildSentInvitesTab(invites),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Lỗi: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedInvitesTab(dynamic invites) {
    if (invites.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(receivedInvitesProvider);
          await ref.read(receivedInvitesProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildEmptyState(
              icon: Icons.mail_outline,
              title: 'Không có lời mời nào',
              description: 'Bạn chưa nhận được lời mời tham gia chuyến đi',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(receivedInvitesProvider);
        await ref.read(receivedInvitesProvider.future);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invites.length,
        itemBuilder: (context, index) {
          final invite = invites[index];
          return _buildReceivedInviteCard(context, invite);
        },
      ),
    );
  }

  Widget _buildSentInvitesTab(dynamic invites) {
    if (invites.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(sentInvitesProvider);
          await ref.read(sentInvitesProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildEmptyState(
              icon: Icons.send_outlined,
              title: 'Chưa gửi lời mời',
              description: 'Bạn chưa gửi lời mời cho ai tham gia chuyến đi',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(sentInvitesProvider);
        await ref.read(sentInvitesProvider.future);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: invites.length,
        itemBuilder: (context, index) {
          final invite = invites[index];
          return _buildSentInviteCard(context, invite);
        },
      ),
    );
  }

  Widget _buildReceivedInviteCard(BuildContext context, dynamic invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
            child: Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey.shade300,
              child: Image.network(
                invite.tripImg ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip name
                Text(
                  invite.tripName ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // From user info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        (invite.fromUserName?.isNotEmpty ?? false)
                            ? invite.fromUserName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lời mời từ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            invite.fromUserName ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Message/content
                Text(
                  invite.content ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                // Status badge and action buttons
                if (invite.invitationStatus?.toLowerCase() != 'pending')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: invite.invitationStatus?.toLowerCase() == 'accepted'
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: invite.invitationStatus?.toLowerCase() == 'accepted'
                            ? Colors.green.shade300
                            : Colors.red.shade300,
                      ),
                    ),
                    child: Text(
                      invite.invitationStatus?.toLowerCase() == 'accepted'
                          ? 'Đã chấp nhận'
                          : 'Đã từ chối',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: invite.invitationStatus?.toLowerCase() == 'accepted'
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  )
                else
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final result = await ref
                                .read(updateInvitationStatusProvider(
                                  {
                                    'invitationId': invite.id,
                                    'status': 'Rejected',
                                  },
                                ).future);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lời mời đã bị từ chối')),
                              );
                            }
                          },
                          child: const Text(
                            'Từ chối',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final result = await ref
                                .read(updateInvitationStatusProvider(
                                  {
                                    'invitationId': invite.id,
                                    'status': 'Accepted',
                                  },
                                ).future);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Lời mời đã được chấp nhận')),
                              );
                            }
                          },
                          child: const Text(
                            'Chấp nhận',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentInviteCard(BuildContext context, dynamic invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(11),
              topRight: Radius.circular(11),
            ),
            child: Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey.shade300,
              child: Image.network(
                invite.tripImg ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip name
                Text(
                  invite.tripName ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Recipient info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade300,
                      child: Text(
                        (invite.toUserName?.isNotEmpty ?? false)
                            ? invite.toUserName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gửi đến',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            invite.toUserName ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.yellow.shade300,
                    ),
                  ),
                  child: Text(
                    invite.invitationStatus?.toLowerCase() == 'pending'
                        ? 'Chờ phản hồi'
                        : invite.invitationStatus?.toLowerCase() == 'accepted'
                            ? 'Đã chấp nhận'
                            : 'Đã từ chối',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.yellow.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

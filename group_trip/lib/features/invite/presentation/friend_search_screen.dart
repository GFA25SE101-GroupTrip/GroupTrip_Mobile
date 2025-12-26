import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/invite/provider/invite_provider.dart';

class FriendSearchScreen extends ConsumerStatefulWidget {
  final String tripDepartureId;

  const FriendSearchScreen({
    Key? key,
    required this.tripDepartureId,
  }) : super(key: key);

  @override
  ConsumerState<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends ConsumerState<FriendSearchScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _searchQuery = '';
  bool _hasSearched = false;

  void _searchUser() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email')),
      );
      return;
    }

    setState(() {
      _searchQuery = _emailController.text;
      _hasSearched = true;
    });
  }

  void _inviteUser(String userId, String userName) async {
    // Gọi sendInvitationProvider
    try {
      // Hiển thị dialog để nhập departure ID và nội dung
      showDialog(
        context: context,
        builder: (context) => _buildInviteDialog(userId, userName),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  Widget _buildInviteDialog(String userId, String userName) {
    final contentController = TextEditingController(text: 'Mời bạn tham gia chuyến đi');

    return AlertDialog(
      title: Text('Mời $userName'),
      content: TextField(
        controller: contentController,
        decoration: const InputDecoration(
          labelText: 'Nội dung lời mời',
          hintText: 'Nhập nội dung lời mời',
          border: OutlineInputBorder(),
        ),
        minLines: 2,
        maxLines: 4,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              // Gọi sendInvitationProvider
              await ref.read(sendInvitationProvider(
                {
                  'toUserId': userId,
                  'tripdepartureId': widget.tripDepartureId,
                  'content': contentController.text,
                },
              ).future);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ Đã gửi lời mời tới $userName'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } catch (e) {
              // Hiển thị error message từ API
              String errorMessage = e.toString();
              if (errorMessage.startsWith('Exception: ')) {
                errorMessage = errorMessage.replaceFirst('Exception: ', '');
              }
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Lỗi: $errorMessage'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          child: const Text('Gửi lời mời'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm bạn bè'),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Thanh tìm kiếm
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Nhập email của người dùng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: const Icon(Icons.email),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _searchUser(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _searchUser,
                    icon: const Icon(Icons.search),
                    label: const Text('Tìm kiếm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Danh sách kết quả
            Expanded(
              child: _buildSearchResultsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Nhập email để tìm kiếm bạn bè',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Gọi ref.watch() ở đây - bên trong widget builder
    final searchResults = ref.watch(userSearchProvider(_searchQuery));

    return searchResults.when(
      data: (users) {
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Không tìm thấy người dùng nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Lỗi: $error',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                image: user.img.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(user.img),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: user.img.isEmpty
                  ? Center(
                      child: Text(
                        user.userName.isNotEmpty ? user.userName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Thông tin người dùng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.userName ?? 'Không xác định',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Nút mời
            ElevatedButton(
              onPressed: () => _inviteUser(user.userId ?? '', user.userName ?? ''),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Mời',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

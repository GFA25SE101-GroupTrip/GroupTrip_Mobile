import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/chat/presentation/chat_detail_screen.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:group_trip/features/chat/data/chat_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _openSearch() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tìm kiếm tin nhắn'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(hintText: 'Nhập từ khóa...'),
            autofocus: true,
            onSubmitted: (_) => Navigator.of(context).pop(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tìm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatListAsyncValue = ref.watch(chatListViewProvider);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      
        centerTitle: true,
        
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(26),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Container(
                  padding: const EdgeInsets.all(2),
                 
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color.fromARGB(255, 63, 101, 161),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color.fromARGB(255, 76, 113, 173),
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    tabs: const [
                      Tab(text: "Riêng tư"),
                      Tab(text: "Chuyến đi"),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // Danh sách tin nhắn
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMessageList(chatListAsyncValue, type: "private"),
                _buildMessageList(chatListAsyncValue, type: "trip"),

              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildMessageList(AsyncValue<dynamic> chatListAsyncValue,
      {String? type}) {
    return chatListAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => const Center(child: Text('Không thể tải danh sách tin nhắn')),
      data: (data) {
        // Normalize different payload shapes into a List<ChatModel>
        final List<ChatModel> items = [];

        if (data == null) {
          // leave empty
        } else if (data is ChatModel) {
          items.add(data);
        } else if (data is List) {
          for (final e in data) {
            if (e is ChatModel) {
              items.add(e);
            } else if (e is Map) {
              try {
                items.add(ChatModel.fromJson(Map<String, dynamic>.from(e)));
              } catch (_) {
                // skip invalid entries
              }
            }
          }
        } else if (data is Map) {
          // wrapper { data: [...] } or single chat object
          if (data.containsKey('data') && data['data'] is List) {
            for (final e in data['data'] as List) {
              if (e is Map) {
                try {
                  items.add(ChatModel.fromJson(Map<String, dynamic>.from(e)));
                } catch (_) {}
              }
            }
          } else {
            try {
              items.add(ChatModel.fromJson(Map<String, dynamic>.from(data)));
            } catch (_) {}
          }
        } else {
          // unknown shape: try to stringify into a single ChatModel
          try {
            items.add(ChatModel.fromJson({'title': data.toString(), 'id': ''}));
          } catch (_) {}
        }

        if (items.isEmpty) return const Center(child: Text('Không có tin nhắn'));

        // Filter by tab: 'trip' = group chats, 'private' = non-group chats
        final displayItems = type == 'trip'
            ? items.where((c) => c.isGroup).toList()
            : type == 'private'
                ? items.where((c) => !c.isGroup).toList()
                : items;

        if (displayItems.isEmpty) return const Center(child: Text('Không có tin nhắn'));

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: displayItems.length,
          itemBuilder: (context, index) {
            final msg = displayItems[index];
            return _buildMessageCard(msg);
          },
        );
      },
    );
  }



  Widget _buildMessageCard(ChatModel msg) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(chatId: msg.id,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(msg.chatImg),
          ),
          title: Text(
            msg.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          subtitle: Text(
            msg.lastMessage ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              const SizedBox(height: 6),
              if (msg.unreadCount > 0)
                Container(
                  height: 12,
                  width: 12,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

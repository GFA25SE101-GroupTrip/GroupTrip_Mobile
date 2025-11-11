import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                      Tab(text: "Đang chờ"),

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
                _buildMessageList(type: "private"),
                _buildMessageList(type: "trip"),
                _buildMessageList(type: "pending"),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList({String? type}) {
    final messages = [
      {
        "avatar": "https://i.pravatar.cc/150?img=1",
        "name": "Hà Nội - Đà Nẵng",
        "message": "Minh Tuấn: Chúng ta khởi hành lúc mấy giờ nhỉ?",
        "time": "10:30",
        "tag": "Chuyến đi",
        "unread": false,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=2",
        "name": "Thu Hà",
        "message": "Chị có rảnh tối nay không? Em muốn hỏi về...",
        "time": "9:45",
        "tag": "Riêng tư",
        "unread": true,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=3",
        "name": "Khám Phá Sài Gòn",
        "message": "Đức Anh: Cảm ơn mọi người đã có chuyến đi tuyệt vời!",
        "time": "Hôm qua",
        "tag": "Chuyến đi",
        "unread": false,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=4",
        "name": "Hoàng Nam",
        "message": "Anh ơi, địa điểm hẹn gặp ở đâu vậy?",
        "time": "2 ngày",
        "tag": "Riêng tư",
        "unread": true,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=5",
        "name": "Phú Quốc 3 Ngày 2 Đêm",
        "message": "Lan Anh: Mọi người đã book khách sạn chưa?",
        "time": "3 ngày",
        "tag": "Chuyến đi",
        "unread": true,
      },
      {
        "avatar": "https://i.pravatar.cc/150?img=6",
        "name": "Mai Linh",
        "message": "Cảm ơn bạn đã chia sẻ kinh nghiệm du lịch!",
        "time": "1 tuần",
        "tag": "Riêng tư",
        "unread": false,
      },
    ];

    // Lọc theo tab
    final filtered =
        type == null
            ? messages
            : messages
                .where(
                  (m) =>
                      m["tag"] == (type == "trip" ? "Chuyến đi" : "Riêng tư"),
                )
                .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final msg = filtered[index];
        return _buildMessageCard(msg);
      },
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> msg) {
    return Container(
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
          backgroundImage: NetworkImage(msg["avatar"]),
        ),
        title: Text(
          msg["name"],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(
          msg["message"],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[700], fontSize: 15),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              msg["time"],
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 6),
            if (msg["unread"])
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
    );
  }
}

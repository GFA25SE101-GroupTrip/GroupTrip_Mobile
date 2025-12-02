import 'package:flutter/material.dart';

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Thông tin nhóm",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 20),

          // ================= GROUP AVATAR =================
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800",
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================= GROUP NAME =================
          const Center(
            child: Text(
              "Trip to Đà Lạt 2025",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 6),
          Center(
            child: Text(
              "5 thành viên · Đang hoạt động",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 20),
          const Divider(),

          // ================= MENU ITEMS =================
          _menuItem(
            icon: Icons.list_alt,
            title: "Xem chi tiết Trip",
            onTap: () {},
          ),

          _menuItem(
            icon: Icons.event,
            title: "Xem ngày khởi hành",
            onTap: () {},
          ),

          _menuItem(
            icon: Icons.group_outlined,
            title: "Xem thành viên",
            onTap: () {},
          ),

          const Divider(),

          // ================= LEAVE GROUP =================
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Rời nhóm
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red.shade400),
                    const SizedBox(width: 12),
                    Text(
                      "Rời Trip / Rời nhóm",
                      style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

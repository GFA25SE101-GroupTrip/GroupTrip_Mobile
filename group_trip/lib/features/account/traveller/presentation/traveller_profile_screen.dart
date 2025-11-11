import 'package:flutter/material.dart';

class TravellerProfileScreen extends StatelessWidget {
  const TravellerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Avatar + online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=3', // placeholder
                  ),
                ),
                
              ],
            ),
            const SizedBox(height: 12),
            // Name and username
            const Text(
              'Minh Anh Nguyễn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '@minhanh_travel',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat('24', 'Chuyến đi'),
                _buildStat('12', 'Bài viết'),
                _buildStat('8', 'Proposals'),
              ],
            ),
            const SizedBox(height: 12),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 21, 39, 53),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Nhắn tin'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color.fromARGB(255, 44, 71, 93),
                        side: const BorderSide(color: Color.fromARGB(255, 44, 71, 93)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Mời tham gia'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Introduction
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Giới thiệu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '🌍 Travel enthusiast | 📷 Photography lover\n'
                    'Khám phá thế giới qua từng chuyến đi nhỏ. '
                    'Chia sẻ những trải nghiệm đáng nhớ và những đam mê tuyệt vời.',
                  ),
                  SizedBox(height: 8),
                 
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tabs for Chuyến đi / Bài viết
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                     
                      labelColor: const Color.fromARGB(255, 37, 34, 34),
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Tab(text: 'Chuyến đi'),
                        Tab(text: 'Bài viết'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Fixed-height TabBarView so it can sit inside the SingleChildScrollView
                  SizedBox(
                    height: 480,
                    child: TabBarView(
                      children: [
                        // Chuyến đi list (reuse post items as placeholders)
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            _buildPostItem(
                              title: 'Hạ Long Bay - Quảng Ninh',
                              description: 'Khám phá vịnh kỳ hằng Hạ Long huyền thoại',
                              date: 'Oct 2024',
                              likes: 24,
                              imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=60',
                            ),
                            _buildPostItem(
                              title: 'Sapa - Lào Cai',
                              description: 'Ruộng bậc thang đẹp như tranh',
                              date: 'Sep 2024',
                              likes: 21,
                              imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=60',
                            ),
                            _buildPostItem(
                              title: 'Hội An - Quảng Nam',
                              description: 'Phố cổ với những chiếc đèn lồng',
                              date: 'Aug 2024',
                              likes: 18,
                              imageUrl: 'https://images.unsplash.com/photo-1505765054928-5f8d8f9c9a7a?auto=format&fit=crop&w=800&q=60',
                            ),
                          ],
                        ),
                        // Bài viết list
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          children: [
                            _buildPostItem(
                              title: 'Kinh nghiệm du lịch Hạ Long',
                              description: 'Mẹo và lịch trình 2 ngày 1 đêm tiết kiệm',
                              date: 'Nov 2024',
                              likes: 42,
                              imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=60',
                            ),
                            _buildPostItem(
                              title: 'Ảnh đẹp Sapa',
                              description: 'Top địa điểm sống ảo ở Sapa',
                              date: 'Oct 2024',
                              likes: 33,
                              imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=60',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String count, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPostItem({
    required String title,
    required String description,
    required String date,
    required int likes,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail image (if provided)
              if (imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 72,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],

              // Textual content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

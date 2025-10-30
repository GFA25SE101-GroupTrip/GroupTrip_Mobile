import 'package:flutter/material.dart';
import 'package:group_trip/features/blog/presentation/widgets/blog_card.dart';
import 'package:group_trip/shared/widgets/appbars/blog_app_bar.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogs = [
      {
        "image": "https://picsum.photos/600/300?1",
        "title": "Khám phá vẻ đẹp hùng vĩ của Sapa trong mùa lúa chín",
        "author": "Saigon Tourist",
        "avatar": "https://i.pravatar.cc/100?img=1",
        "tags": ["#nature", "#mountain", "#sapa"],
        "likes": 324,
        "category": "agency"
      },
      {
        "image": "https://picsum.photos/600/300?2",
        "title": "Hành trình khám phá ẩm thực đường phố Sài Gòn",
        "author": "Minh Phương",
        "avatar": "https://i.pravatar.cc/100?img=2",
        "tags": ["#food", "#saigon", "#streetfood"],
        "likes": 122,
        "category": "traveler"
      },
      {
        "image": "https://picsum.photos/600/300?3",
        "title": "Phiêu lưu một mình qua rừng Cát Tiên",
        "author": "Hoàng Nam",
        "avatar": "https://i.pravatar.cc/100?img=3",
        "tags": ["#adventure", "#jungle", "#solo"],
        "likes": 97,
        "category": "traveler"
      },
      {
        "image": "https://picsum.photos/600/300?4",
        "title": "Hội An – Thành phố cổ kính trong ánh hoàng hôn",
        "author": "Viettravel",
        "avatar": "https://i.pravatar.cc/100?img=4",
        "tags": ["#heritage", "#hoian", "#travel"],
        "likes": 156,
        "category": "agency"
      },
    ];

    return Scaffold(
      appBar: BlogAppBar(
    onSearch: (value) {
      print('Đang tìm: $value');
    },
    onAddPost: () {
      print('Thêm bài viết mới');
      // Navigator.push(...);
    },
  ),
      body: ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (context, index) {
          final b = blogs[index];
          return BlogCard(
            imageUrl: b["image"] as String,
            title: b["title"] as String,
            author: b["author"] as String,
            authorAvatar: b["avatar"] as String,
            tags: List<String>.from(b["tags"] as List<dynamic>),
            likes: b["likes"]! as int,
            category: b["category"]! as String,
          );
        },
      ),
    );
  }
}

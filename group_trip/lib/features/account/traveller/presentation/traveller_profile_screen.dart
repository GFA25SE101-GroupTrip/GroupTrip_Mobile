import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/account/traveller/presentation/widgets/buildPostItem.dart';
import 'package:group_trip/features/account/traveller/providers/tral_provider.dart';
import 'package:group_trip/features/account/traveller/data/tral_model.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';

class TravellerProfileScreen extends ConsumerStatefulWidget {
  final String travellerId;
  const TravellerProfileScreen({super.key, required this.travellerId});

  @override
  ConsumerState<TravellerProfileScreen> createState() => _TravellerProfileScreenState();
}

class _TravellerProfileScreenState extends ConsumerState<TravellerProfileScreen> {
  // one-time contact check state
  bool _checkedContact = false;
  bool _contactExists = false;
  bool _checkingContact = false;

  @override
  Widget build(BuildContext context) {
    final travellerAsync = ref.watch(travellerModelProvider(widget.travellerId));
    final travellerBlogsAsync = ref.watch(travellerBlogsProvider(widget.travellerId));
    
    return travellerAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: Text('Lỗi khi tải hồ sơ: $e')),
      ),
      data: (traveller) {
        if (traveller == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(child: Text('Không có dữ liệu người dùng')),
          );
        }

        // trigger one-time contact check
        _maybeCheckContact(traveller.userId);

        // pass the blogs async snapshot into the builder so Bài viết tab can render
        return _buildProfileWithModel(context, traveller, travellerBlogsAsync);
      },
    );
  }

  void _maybeCheckContact(String userId) {
    if (!_checkedContact && userId.isNotEmpty && !_checkingContact) {
      _checkingContact = true;
      ref.read(checkContactExistsProvider(userId).future).then((exists) {
        if (!mounted) return;
        setState(() {
          _contactExists = exists;
          _checkedContact = true;
          _checkingContact = false;
        });
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _contactExists = false;
          _checkedContact = true;
          _checkingContact = false;
        });
      });
    }
  }

  Widget _buildProfileWithModel(BuildContext context, TravellerModel traveller, AsyncValue<List<BlogsTraveller>?> travellerBlogsAsync) {
    final primaryColor = const Color.fromARGB(255, 21, 39, 53);

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
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: traveller.imageUrl.isNotEmpty ? NetworkImage(traveller.imageUrl) : null,
              child: traveller.imageUrl.isEmpty ? const Icon(Icons.person, size: 48) : null,
            ), 
            const SizedBox(height: 12),
            // Full name and username
            Text(
              traveller.fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              traveller.userName ?? '@${traveller.userId.isNotEmpty ? traveller.userId.substring(0, 8) : ''}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat('${traveller.tripCount}', 'Chuyến đi'),
                _buildStat('${traveller.blogCount}', 'Bài viết'),
                _buildStat('${traveller.proposalCount}', 'Proposals'),
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
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_contactExists) {
                          // open existing chat
                          context.push('/chat');
                        } else {
                          // start new chat / placeholder
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bắt đầu trò chuyện...')));
                          // Optionally navigate to chat to initiate conversation
                          context.push('/chat');
                        }
                      },
                      child: Text(_contactExists ? 'Mở tin nhắn' : 'Trò chuyện'),
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
                children: [
                  const Text(
                    'Giới thiệu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(traveller.bio),
                  const SizedBox(height: 8),
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
                            BuildPostItem(
                              title: 'Hạ Long Bay - Quảng Ninh',
                              date: 'Oct 2024',
                              imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=60',
                            ),
                            BuildPostItem(
                              title: 'Sapa - Lào Cai',
                              date: 'Sep 2024',
                              imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=800&q=60',
                            ),
                            BuildPostItem(
                              title: 'Hội An - Quảng Nam',
                              date: 'Aug 2024',
                              imageUrl: 'https://images.unsplash.com/photo-1505765054928-5f8d8f9c9a7a?auto=format&fit=crop&w=800&q=60',
                            ),
                          ],
                        ),
                        // Bài viết list - render from provider (supports single or multiple entries)
                        travellerBlogsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, st) => Center(child: Text('Lỗi khi tải bài viết: $e')),
                          data: (blogs) {
                            if (blogs == null) {
                              return const Center(child: Text('Chưa có bài viết'));
                            }

                            // 'blogs' is expected to be a List<BlogsTraveller>.
                            final items = blogs;

                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final b = items[index];
                                final firstImage = b.images.isNotEmpty ? b.images.first.imgUrl : null;
                                final pd = b.publishDate;
                                final dateStr = '${pd.year}-${pd.month.toString().padLeft(2, '0')}-${pd.day.toString().padLeft(2, '0')}';

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: BuildPostItem(
                                    title: b.title,
                                    date: dateStr,
                                    imageUrl: firstImage,
                                  ),
                                );
                              },
                            );
                          },
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

 
}

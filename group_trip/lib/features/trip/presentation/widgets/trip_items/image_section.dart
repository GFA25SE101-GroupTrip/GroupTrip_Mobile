import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  final List<dynamic> images; // can be String, Map, ImageData/TripImage
  const ImageSection({super.key, required this.images});

  String _extractUrl(dynamic item) {
    if (item == null) return '';
    if (item is String) return item;
    try {
      if (item is Map) {
        if (item.containsKey('img_url')) return item['img_url']?.toString() ?? '';
        if (item.containsKey('imgUrl')) return item['imgUrl']?.toString() ?? '';
        if (item.containsKey('url')) return item['url']?.toString() ?? '';
        if (item.containsKey('image')) return item['image']?.toString() ?? '';
      }
      // try common field names on model-like objects
      final dyn = item as dynamic;
      if (dyn.imgUrl != null) return dyn.imgUrl.toString();
      if (dyn.img_url != null) return dyn.img_url.toString();
      if (dyn.url != null) return dyn.url.toString();
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final urls = images.map(_extractUrl).where((s) => s.isNotEmpty).toList();

    if (urls.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Center(child: Text('Không có ảnh trong thư viện')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thư viện ảnh',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 4 / 3,
          ),
          itemCount: urls.length,
          itemBuilder: (context, index) {
            final url = urls[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ImageViewerPage(urls: urls, initialIndex: index),
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: Colors.grey.shade200,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ImageViewerPage extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  const ImageViewerPage({super.key, required this.urls, this.initialIndex = 0});

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('${_index + 1} / ${widget.urls.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.urls.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) {
          final url = widget.urls[i];
          return InteractiveViewer(
            child: Center(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

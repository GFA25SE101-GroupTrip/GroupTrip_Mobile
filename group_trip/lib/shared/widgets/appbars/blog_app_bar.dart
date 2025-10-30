import 'package:flutter/material.dart';

class BlogAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;
  final VoidCallback? onAddPost;

  const BlogAppBar({
    super.key,
    this.onSearch,
    this.onAddPost,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent, // Ngăn Material 3 tự thêm tint khi scroll
      title: Builder(
        builder: (context) {
          // These locals are captured by the StatefulBuilder closure so the
          // searching state survives while the AppBar stays in the widget tree.
          final TextEditingController _searchController = TextEditingController();
          final FocusNode _focusNode = FocusNode();
          bool _isSearching = false;

          return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
            child: _isSearching
            ? Padding(
            key: const ValueKey('searchField'),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  autofocus: true,
                  onChanged: onSearch,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                hintText: 'Tìm kiếm blog...',
                hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14),
                prefixIcon: Icon(Icons.search,
                    color: Colors.grey.shade600, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 12),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  onSearch?.call('');
                  setState(() => _isSearching = false);
                  // Unfocus to dismiss keyboard
                  _focusNode.unfocus();
                },
              ),
                ],
              ),
            ),
              )
            : Padding(
            key: const ValueKey('searchIcon'),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 52,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
              icon: Icon(Icons.search, color: Colors.grey[800]),
              onPressed: () {
                setState(() => _isSearching = true);
                // Delay focusing until the frame completes
                Future.delayed(Duration.zero, () {
                  _focusNode.requestFocus();
                });
              },
                ),
              ),
            ),
              ),
          );
        },
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: SizedBox(
        height: 36,
        child: ElevatedButton(
          onPressed: onAddPost,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('Đăng bài', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

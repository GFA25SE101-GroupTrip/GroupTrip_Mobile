// lib/core/ui/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/features/chat/providers/chat_provider.dart';
import 'package:group_trip/features/account/traveller/presentation/traveller_profile_screen.dart';
import 'package:group_trip/features/auth/presentation/screens/register_screen.dart';
import 'package:group_trip/features/blog/presentation/blog_screen.dart';
import 'package:group_trip/features/chat/presentation/chat_screen.dart';
import 'package:group_trip/features/profile/presentation/profile_screen.dart';
import 'package:group_trip/features/trip/presentation/cancel_process_screen.dart';
import 'package:group_trip/features/trip/presentation/confirm_process_screen.dart';
import 'package:group_trip/features/trip/presentation/deposit_process_screen.dart';
import 'package:group_trip/features/trip/presentation/pending_process_screen.dart';
import 'package:group_trip/features/trip/presentation/trip_screen.dart';
import 'package:group_trip/shared/widgets/bottom_navbar.dart';


class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;

  final _pages = [
    const TripScreen(),
    const ChatScreen(),
    const BlogScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _totalUnreadFrom(AsyncValue<dynamic> chatList) {
    try {
      if (chatList is AsyncData && chatList.value != null) {
        final val = chatList.value;
        List items = [];
        if (val is List) items = val;
        else if (val is Map && val['data'] is List) items = val['data'];

        int sum = 0;
        for (final e in items) {
          try {
            if (e is Map && e.containsKey('unreadCount')) {
              final u = e['unreadCount'];
              if (u is int) sum += u;
              else if (u is String) sum += int.tryParse(u) ?? 0;
            } else {
              // attempt to access dynamic property
              try {
                final u = (e as dynamic).unreadCount;
                if (u is int) sum += u;
                else if (u is String) sum += int.tryParse(u) ?? 0;
              } catch (_) {}
            }
          } catch (_) {}
        }
        return sum;
      }
    } catch (_) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatListViewProvider);
    final totalUnread = _totalUnreadFrom(chatList);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        chatUnreadCount: totalUnread,
      ),
    );
  }
}

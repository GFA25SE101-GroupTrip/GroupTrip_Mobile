// lib/core/ui/main_layout.dart
import 'package:flutter/material.dart';
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


class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final _pages = [
    const TripScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const AppNavbar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

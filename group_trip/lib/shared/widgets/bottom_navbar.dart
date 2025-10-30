import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      transform: Matrix4.identity()..scale(1.05),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
        color: Colors.black26,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 87, 87, 166), // màu icon được chọn (xanh đậm)
        unselectedItemColor: Colors.grey.shade400, // màu icon chưa chọn
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        iconSize: 28,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.card_travel : Icons.card_travel_outlined,
            ),
            
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_bubble_outline
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.favorite : Icons.favorite_border,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 4 ? Icons.person : Icons.account_circle_outlined,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:siabsen_app/core/theme/app_colors.dart';
import 'package:siabsen_app/features/attendance/presentation/screens/home_screen.dart';
import 'package:siabsen_app/features/overtime/presentation/screens/overtime_screen.dart';
import 'package:siabsen_app/features/profile/presentation/screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    OvertimeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(icon: Icons.home_rounded, index: 0),
              _navItem(icon: Icons.timer_rounded, index: 1),
              _navItem(icon: Icons.person_rounded, index: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({required IconData icon, required int index}) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: Icon(
        icon,
        color: _selectedIndex == index ? AppColors.primary : Colors.grey,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:siabsen_app/features/attendance/presentation/screens/home_screen.dart';
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
      body: _pages[_selectedIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // nanti untuk scan atau check in
        },
        child: const Icon(Icons.add),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              IconButton(
                onPressed: () => _onItemTapped(0),
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              ),

              const SizedBox(width: 40),

              IconButton(
                onPressed: () => _onItemTapped(1),
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 1
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
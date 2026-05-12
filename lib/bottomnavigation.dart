import 'package:flutter/material.dart';
import 'package:kids/features/parent/presentation/screens/parent_zone_page.dart';
import 'package:kids/privacypolicy.dart';

import 'homeScreen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 1;

  static final List<Widget> _pages = <Widget>[
    const ParentZonePage(),
    const HomeScreen(),
    const PrivacyPolicy(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        selectedItemColor: const Color(0xFFF19335),
        selectedIconTheme: const IconThemeData(color: Color(0xFFF19335)),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined),
            label: 'Parent',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/12Group 1.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/privacy.png')),
            label: 'Privacy',
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}

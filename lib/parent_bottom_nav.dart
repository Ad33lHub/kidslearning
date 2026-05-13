import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:kids/features/parent/presentation/screens/parent_dashboard_screen.dart';
import 'package:kids/features/parent/presentation/screens/child_list_screen.dart';
import 'package:kids/features/parent/presentation/screens/activity_history_screen.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';
import 'package:kids/privacypolicy.dart';

class ParentBottomNav extends StatefulWidget {
  const ParentBottomNav({super.key});

  @override
  State<ParentBottomNav> createState() => _ParentBottomNavState();
}

class _ParentBottomNavState extends State<ParentBottomNav> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ParentDashboardScreen(),
    ChildListScreen(),
    ActivityHistoryScreen(),
    PrivacyPolicy(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Exit Parent Zone?',
          style: TextStyle(fontFamily: 'arlrdbd'),
        ),
        content: const Text(
          'Do you want to return to the selection screen?',
          style: TextStyle(fontFamily: 'arlrdbd'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay', style: TextStyle(fontFamily: 'arlrdbd')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Exit',
              style: TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showExitDialog();
        if (shouldExit && mounted) {
          // Go back to mode selection screen
          context.read<AppState>().setMode(null);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: _ParentFloatingNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class _ParentFloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _ParentFloatingNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.people_rounded, label: 'Children'),
    _NavItem(icon: Icons.history_rounded, label: 'History'),
    _NavItem(icon: Icons.shield_rounded, label: 'Privacy'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 80.0 : 20.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        (bottomPadding > 0 ? bottomPadding + 8 : 20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            _items.length,
            (i) => _NavBarItem(
              item: _items[i],
              isSelected: selectedIndex == i,
              onTap: () => onTap(i),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.headerGradient,
                )
              : null,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 24,
              color: isSelected ? Colors.white : AppColors.navUnselected,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

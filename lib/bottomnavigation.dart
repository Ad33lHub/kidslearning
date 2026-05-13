import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:kids/features/parent/presentation/screens/parent_zone_page.dart';
import 'package:kids/privacypolicy.dart';

import 'homeScreen.dart';
import 'package:kids/features/learning/presentation/screens/activities_menu_screen.dart';
import 'package:kids/features/learning/presentation/screens/rewards_screen.dart';
import 'package:kids/core/services/background_music_service.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 1;

  // Kid-friendly pages
  static const List<Widget> _pages = <Widget>[
    ActivitiesMenuScreen(),
    HomeScreen(),
    RewardsScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
    setState(() {
      _selectedIndex = index;
    });
    
    // Pause music if not on Home screen (index 1)
    if (index != 1) {
      BackgroundMusicService.instance.pause();
    } else {
      BackgroundMusicService.instance.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHome = _selectedIndex == 1;
    final bar = _FloatingNavBar(
      selectedIndex: _selectedIndex,
      onTap: _onItemTapped,
      glass: isHome,
    );

    return Scaffold(
      backgroundColor: isHome ? const Color(0xFF0E0E10) : AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: bar,
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool glass;

  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onTap,
    this.glass = false,
  });

  static const _items = [
    _NavItem(icon: Icons.grid_view_rounded, label: 'Activities'),
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'Rewards'),
  ];

  @override
  Widget build(BuildContext context) {
    // Account for bottom system gesture bar
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    // Adaptive horizontal padding for different screen sizes
    final horizontalPadding = screenWidth > 600 ? 60.0 : 20.0;

    final bar = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: glass
            ? Colors.white.withOpacity(0.06)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: glass
            ? Border.all(color: Colors.white.withOpacity(0.18))
            : null,
        boxShadow: [
          BoxShadow(
            color: (glass
                    ? const Color(0xFFB600F8)
                    : AppColors.primary)
                .withOpacity(glass ? 0.35 : 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          if (!glass)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List.generate(
            _items.length,
            (i) => _NavBarItem(
              item: _items[i],
              isSelected: selectedIndex == i,
              glass: glass,
              onTap: () => onTap(i),
            ),
          ),
          _MuteToggle(glass: glass),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        // Ensure the bar clears the system gesture bar
        (bottomPadding > 0 ? bottomPadding + 8 : 20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: glass
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: bar,
              )
            : bar,
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final bool glass;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.glass = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedGradient = glass
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB600F8), Color(0xFFEBB2FF)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.headerGradient,
          );
    final unselectedColor =
        glass ? Colors.white.withOpacity(0.65) : AppColors.navUnselected;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? selectedGradient : null,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected && glass
              ? [
                  BoxShadow(
                    color: const Color(0xFFB600F8).withOpacity(0.55),
                    blurRadius: 16,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: 26,
              color: isSelected ? Colors.white : unselectedColor,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 13,
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

class _MuteToggle extends StatefulWidget {
  final bool glass;
  const _MuteToggle({required this.glass});

  @override
  State<_MuteToggle> createState() => _MuteToggleState();
}

class _MuteToggleState extends State<_MuteToggle> {
  @override
  Widget build(BuildContext context) {
    final isMuted = BackgroundMusicService.instance.isMuted;
    final unselectedColor =
        widget.glass ? Colors.white.withOpacity(0.65) : AppColors.navUnselected;

    return GestureDetector(
      onTap: () {
        setState(() {
          BackgroundMusicService.instance.toggleMute();
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMuted ? Colors.red.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          isMuted ? Icons.music_off_rounded : Icons.music_note_rounded,
          size: 26,
          color: isMuted ? Colors.redAccent : unselectedColor,
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

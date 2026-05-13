import 'package:flutter/material.dart';
import 'package:kids/core/theme/app_colors.dart';

import 'animal_sound_screen.dart';
import 'color_matching_screen.dart';
import 'counting_activity_screen.dart';
import 'drag_drop_quiz_screen.dart';
import 'letter_matching_screen.dart';
import 'letter_tracing_screen.dart';
import 'number_tracing_screen.dart';
import 'rhymes_screen.dart';
import 'shape_matching_screen.dart';

class ActivitiesMenuScreen extends StatelessWidget {
  const ActivitiesMenuScreen({super.key});

  static const _items = [
    _ActivityItem('Letter Tracing', '✏️', AppColors.gradientAlphabet),
    _ActivityItem('Number Tracing', '🔢', AppColors.gradientNumbers),
    _ActivityItem('Letter Matching', '🔤', AppColors.gradientMonths),
    _ActivityItem('Counting Fun', '🎯', AppColors.gradientColors),
    _ActivityItem('Color Matching', '🎨', AppColors.gradientAnimals),
    _ActivityItem('Shape Matching', '🔷', AppColors.gradientShapes),
    _ActivityItem('Animal Sounds', '🦁', AppColors.gradientListen),
    _ActivityItem('Rhymes', '🎵', AppColors.gradientRewards),
    _ActivityItem('Drag & Drop', '🧲', AppColors.gradientActivities),
  ];

  void _navigate(BuildContext context, int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = const LetterTracingScreen();
        break;
      case 1:
        screen = const NumberTracingScreen();
        break;
      case 2:
        screen = const LetterMatchingScreen();
        break;
      case 3:
        screen = const CountingActivityScreen();
        break;
      case 4:
        screen = const ColorMatchingScreen();
        break;
      case 5:
        screen = const ShapeMatchingScreen();
        break;
      case 6:
        screen = const AnimalSoundScreen();
        break;
      case 7:
        screen = const RhymesScreen();
        break;
      case 8:
        screen = const DragDropQuizScreen();
        break;
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'More Activities',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.gradientActivities,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -20,
                      right: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 16,
                      left: 20,
                      child: Text('🎮', style: TextStyle(fontSize: 36)),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: const Color(0xFFF97316),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ActivityCard(
                  item: _items[i],
                  onTap: () => _navigate(context, i),
                ),
                childCount: _items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final _ActivityItem item;
  final VoidCallback onTap;

  const _ActivityCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: item.gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: item.gradient.last.withOpacity(0.40),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -18,
              right: -18,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String emoji;
  final List<Color> gradient;

  const _ActivityItem(this.title, this.emoji, this.gradient);
}

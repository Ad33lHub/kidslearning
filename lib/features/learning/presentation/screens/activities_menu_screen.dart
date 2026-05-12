import 'package:flutter/material.dart';

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
    _ActivityItem('Letter Tracing', '✏️', Color(0xFFE4F2E6)),
    _ActivityItem('Number Tracing', '🔢', Color(0xFFFFF9F4)),
    _ActivityItem('Letter Matching', '🔤', Color(0xFFEBE8FD)),
    _ActivityItem('Counting Fun', '🎯', Color(0xFFFEF9E4)),
    _ActivityItem('Color Matching', '🎨', Color(0xFFE4F2E6)),
    _ActivityItem('Shape Matching', '🔷', Color(0xFFFFF9F4)),
    _ActivityItem('Animal Sounds', '🦁', Color(0xFFEBE8FD)),
    _ActivityItem('Rhymes', '🎵', Color(0xFFFEF9E4)),
    _ActivityItem('Drag & Drop', '🧲', Color(0xFFFFE4E4)),
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'More Activities',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _items.length,
          itemBuilder: (_, i) {
            final item = _items[i];
            return GestureDetector(
              onTap: () => _navigate(context, i),
              child: Container(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String emoji;
  final Color color;
  const _ActivityItem(this.title, this.emoji, this.color);
}

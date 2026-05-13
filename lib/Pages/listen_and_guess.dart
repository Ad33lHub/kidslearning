import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/ListenGuessSongs/Alphabet.dart';
import 'package:kids/ListenGuessSongs/Animal.dart';
import 'package:kids/ListenGuessSongs/Brid.dart';
import 'package:kids/ListenGuessSongs/Color.dart';
import 'package:kids/ListenGuessSongs/Flower.dart';
import 'package:kids/ListenGuessSongs/Fruit.dart';
import 'package:kids/ListenGuessSongs/Month.dart';
import 'package:kids/ListenGuessSongs/Number.dart';
import 'package:kids/ListenGuessSongs/Shapes.dart';
import 'package:kids/ListenGuessSongs/Vegitable.dart';
import 'package:kids/core/theme/app_colors.dart';

class ListenGuess extends StatefulWidget {
  const ListenGuess({super.key});

  @override
  State<ListenGuess> createState() => _ListenGuessState();
}

class _ListenGuessState extends State<ListenGuess> {
  int index = 0;
  final FlutterTts _tts = FlutterTts();

  static const _items = [
    _ListenItem('Alphabet', 'assets/images/Alphabet.png', '🔤', 'Apple', AppColors.gradientAlphabet),
    _ListenItem('Numbers', 'assets/images/Numbers.png', '🔢', 'Zero', AppColors.gradientNumbers),
    _ListenItem('Colors', 'assets/images/Color.png', '🎨', 'Aqua', AppColors.gradientColors),
    _ListenItem('Shapes', 'assets/images/Shapes.png', '🔷', 'Arrow', AppColors.gradientShapes),
    _ListenItem('Animals', 'assets/images/Animals.png', '🦁', 'Bear', AppColors.gradientAnimals),
    _ListenItem('Birds', 'assets/images/Birds.png', '🦜', 'Eagle', AppColors.gradientBirds),
    _ListenItem('Flowers', 'assets/images/Flowers.png', '🌸', 'Rose', AppColors.gradientFlowers),
    _ListenItem('Fruits', 'assets/images/Fruit.png', '🍎', 'Apple', AppColors.gradientFruits),
    _ListenItem('Months', 'assets/images/Month.png', '📅', 'January', AppColors.gradientMonths),
    _ListenItem('Vegetables', 'assets/images/Vegitable.png', '🥦', 'Bell Pepper', AppColors.gradientVegetables),
  ];

  void _navigate(int i) {
    _tts.speak(_items[i].ttsWord);
    final Widget screen;
    switch (i) {
      case 0:
        screen = const AlphabetSong();
        break;
      case 1:
        screen = const NumberSong();
        break;
      case 2:
        screen = const ColorSong();
        break;
      case 3:
        screen = const ShapesSong();
        break;
      case 4:
        screen = const AnimalsSong();
        break;
      case 5:
        screen = const BirdsSong();
        break;
      case 6:
        screen = const FlowerSong();
        break;
      case 7:
        screen = const FruitSong();
        break;
      case 8:
        screen = const MonthSong();
        break;
      case 9:
        screen = const VegitableSong();
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
                'Listen And Guess',
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
                    colors: AppColors.gradientListen,
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
                      child: Text('🎧', style: TextStyle(fontSize: 36)),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: const Color(0xFF10B981),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ListenCard(
                  item: _items[i],
                  onTap: () => _navigate(i),
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

class _ListenCard extends StatelessWidget {
  final _ListenItem item;
  final VoidCallback onTap;

  const _ListenCard({required this.item, required this.onTap});

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
              color: item.gradient.last.withOpacity(0.42),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        item.image,
                        height: 52,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ListenItem {
  final String label;
  final String image;
  final String emoji;
  final String ttsWord;
  final List<Color> gradient;

  const _ListenItem(
    this.label,
    this.image,
    this.emoji,
    this.ttsWord,
    this.gradient,
  );
}

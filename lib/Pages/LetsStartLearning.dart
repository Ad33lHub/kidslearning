import 'package:flutter/material.dart';
import 'package:kids/Learning/Alphabet.dart';
import 'package:kids/Learning/Animals.dart';
import 'package:kids/Learning/Brids.dart';
import 'package:kids/Learning/Colors.dart' as learning_colors;
import 'package:kids/Learning/Flowers.dart';
import 'package:kids/Learning/Fruit.dart';
import 'package:kids/Learning/Month.dart';
import 'package:kids/Learning/Number.dart';
import 'package:kids/Learning/Shapes.dart';
import 'package:kids/Learning/Vegitable.dart';
import 'package:kids/core/theme/app_colors.dart';

class LetsStartLearning extends StatefulWidget {
  final int index;
  const LetsStartLearning(this.index, {super.key});

  @override
  State<LetsStartLearning> createState() => _LetsStartLearningState();
}

class _LetsStartLearningState extends State<LetsStartLearning> {
  static const _categories = [
    _Category(
      label: 'Alphabet',
      image: 'assets/images/number.png',
      emoji: '🔤',
      gradient: AppColors.gradientAlphabet,
    ),
    _Category(
      label: 'Numbers',
      image: 'assets/images/Numbers.png',
      emoji: '🔢',
      gradient: AppColors.gradientNumbers,
    ),
    _Category(
      label: 'Colors',
      image: 'assets/images/Color.png',
      emoji: '🎨',
      gradient: AppColors.gradientColors,
    ),
    _Category(
      label: 'Shapes',
      image: 'assets/images/Shapes.png',
      emoji: '🔷',
      gradient: AppColors.gradientShapes,
    ),
    _Category(
      label: 'Animals',
      image: 'assets/images/Animals.png',
      emoji: '🦁',
      gradient: AppColors.gradientAnimals,
    ),
    _Category(
      label: 'Birds',
      image: 'assets/images/Birds.png',
      emoji: '🦜',
      gradient: AppColors.gradientBirds,
    ),
    _Category(
      label: 'Flowers',
      image: 'assets/images/Flowers.png',
      emoji: '🌸',
      gradient: AppColors.gradientFlowers,
    ),
    _Category(
      label: 'Fruits',
      image: 'assets/images/Fruit.png',
      emoji: '🍎',
      gradient: AppColors.gradientFruits,
    ),
    _Category(
      label: 'Months',
      image: 'assets/images/Month.png',
      emoji: '📅',
      gradient: AppColors.gradientMonths,
    ),
    _Category(
      label: 'Vegetables',
      image: 'assets/images/Vegitable.png',
      emoji: '🥦',
      gradient: AppColors.gradientVegetables,
    ),
  ];

  void _navigate(int i) {
    final Widget screen;
    switch (i) {
      case 0:
        screen = const Alphabet();
        break;
      case 1:
        screen = const Numbers();
        break;
      case 2:
        screen = learning_colors.Color(widget.index);
        break;
      case 3:
        screen = const Shapes();
        break;
      case 4:
        screen = const Animal();
        break;
      case 5:
        screen = const Brids();
        break;
      case 6:
        screen = const Flower();
        break;
      case 7:
        screen = const Fruits();
        break;
      case 8:
        screen = Month();
        break;
      case 9:
        screen = const Vegitable();
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
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _GradientSliverAppBar(title: "Let's Start Learning"),
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
                (context, i) => _CategoryCard(
                  category: _categories[i],
                  onTap: () => _navigate(i),
                ),
                childCount: _categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientSliverAppBar extends StatelessWidget {
  final String title;
  const _GradientSliverAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          title,
          style: const TextStyle(
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
              colors: AppColors.headerGradient,
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
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 30,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.primaryDark,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _Category category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: category.gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: category.gradient.last.withOpacity(0.42),
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    category.image,
                    height: 56,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  category.label,
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.emoji,
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

class _Category {
  final String label;
  final String image;
  final String emoji;
  final List<Color> gradient;

  const _Category({
    required this.label,
    required this.image,
    required this.emoji,
    required this.gradient,
  });
}

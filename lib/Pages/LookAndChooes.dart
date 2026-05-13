import 'package:flutter/material.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/Quiz/AnimalQuize.dart';
import 'package:kids/Quiz/BirdQuize.dart';
import 'package:kids/Quiz/ColorQuiz.dart';
import 'package:kids/Quiz/FlowerQuize.dart';
import 'package:kids/Quiz/FruitQuize.dart';
import 'package:kids/Quiz/MonthQuize.dart';
import 'package:kids/Quiz/NumberQuiz.dart';
import 'package:kids/Quiz/ShapeQuiz.dart';
import 'package:kids/Quiz/VegitableQuiz.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/unlock_service.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class _QuizCategoryItem {
  final String moduleKey;
  final String label;
  final String image;
  final String emoji;
  final List<Color> gradient;
  final WidgetBuilder builder;

  const _QuizCategoryItem({
    required this.moduleKey,
    required this.label,
    required this.image,
    required this.emoji,
    required this.gradient,
    required this.builder,
  });
}

class LookAndChooes extends StatefulWidget {
  final int index;
  const LookAndChooes(this.index, {super.key});

  @override
  State<LookAndChooes> createState() => _LookAndChooesState();
}

class _LookAndChooesState extends State<LookAndChooes> {
  Set<String> _unlocked = const {};
  bool _loading = true;

  static final _items = <_QuizCategoryItem>[
    _QuizCategoryItem(
      moduleKey: 'alphabet',
      label: 'ABC Quiz',
      image: 'assets/images/Alphabet.png',
      emoji: '🔤',
      gradient: AppColors.gradientAlphabet,
      builder: (_) => const ABCQuiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'numbers',
      label: 'Number Quiz',
      image: 'assets/images/Numbers.png',
      emoji: '🔢',
      gradient: AppColors.gradientNumbers,
      builder: (_) => const Numberquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'colors',
      label: 'Color Quiz',
      image: 'assets/images/Color.png',
      emoji: '🎨',
      gradient: AppColors.gradientColors,
      builder: (_) => const Colorquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'shapes',
      label: 'Shape Quiz',
      image: 'assets/images/Shapes.png',
      emoji: '🔷',
      gradient: AppColors.gradientShapes,
      builder: (_) => const Shapequiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'animals',
      label: 'Animal Quiz',
      image: 'assets/images/Animals.png',
      emoji: '🦁',
      gradient: AppColors.gradientAnimals,
      builder: (_) => const AnimalQuiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'birds',
      label: 'Bird Quiz',
      image: 'assets/images/Birds.png',
      emoji: '🦜',
      gradient: AppColors.gradientBirds,
      builder: (_) => const Birdquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'flowers',
      label: 'Flower Quiz',
      image: 'assets/images/Flowers.png',
      emoji: '🌸',
      gradient: AppColors.gradientFlowers,
      builder: (_) => const Flowerquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'fruits',
      label: 'Fruit Quiz',
      image: 'assets/images/Fruit.png',
      emoji: '🍎',
      gradient: AppColors.gradientFruits,
      builder: (_) => const Fruitquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'months',
      label: 'Month Quiz',
      image: 'assets/images/Month.png',
      emoji: '📅',
      gradient: AppColors.gradientMonths,
      builder: (_) => const Monthquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'vegetables',
      label: 'Vegetable Quiz',
      image: 'assets/images/Vegitable.png',
      emoji: '🥦',
      gradient: AppColors.gradientVegetables,
      builder: (_) => const Vegitablequiz(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadUnlocks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadUnlocks() async {
    final childId = context.read<AppState>().currentChild?.id;
    final unlocked = await UnlockService.instance.unlockedFor(childId);
    if (!mounted) return;
    setState(() {
      _unlocked = unlocked;
      _loading = false;
    });
  }

  void _onTapItem(_QuizCategoryItem item) {
    if (!_unlocked.contains(item.moduleKey)) {
      final prereq = UnlockService.instance.prerequisiteFor(item.moduleKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Finish "$prereq" first to unlock this! 🔒',
            style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.white),
          ),
        ),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: item.builder))
        .then((_) => _loadUnlocks());
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
                'Look And Choose',
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
                    colors: AppColors.gradientQuiz,
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
                      child: Text('🧠', style: TextStyle(fontSize: 36)),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: const Color(0xFF0EA5E9),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          if (_loading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
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
                  (_, i) => _QuizCard(
                    item: _items[i],
                    isUnlocked: _unlocked.contains(_items[i].moduleKey),
                    onTap: () => _onTapItem(_items[i]),
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

class _QuizCard extends StatelessWidget {
  final _QuizCategoryItem item;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _QuizCard({
    required this.item,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.65,
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
                  const SizedBox(height: 12),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 15,
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
              if (!isUnlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.lock_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

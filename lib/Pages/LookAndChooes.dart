import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/core/widgets/cosmic_theme.dart';
import 'package:provider/provider.dart';

class _QuizItem {
  final String moduleKey;
  final String label;
  final String image;
  final WidgetBuilder builder;
  const _QuizItem({
    required this.moduleKey,
    required this.label,
    required this.image,
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

  static final _items = <_QuizItem>[
    _QuizItem(moduleKey: 'alphabet',  label: 'ABC quiz',       image: 'assets/images/Alphabet.png', builder: (_) => const ABCQuiz()),
    _QuizItem(moduleKey: 'numbers',   label: 'Number quiz',    image: 'assets/images/Numbers.png',  builder: (_) => const Numberquiz()),
    _QuizItem(moduleKey: 'colors',    label: 'Color quiz',     image: 'assets/images/Color.png',    builder: (_) => const Colorquiz()),
    _QuizItem(moduleKey: 'shapes',    label: 'Shape quiz',     image: 'assets/images/Shapes.png',   builder: (_) => const Shapequiz()),
    _QuizItem(moduleKey: 'animals',   label: 'Animal quiz',    image: 'assets/images/Animals.png',  builder: (_) => const AnimalQuiz()),
    _QuizItem(moduleKey: 'birds',     label: 'Bird quiz',      image: 'assets/images/Birds.png',    builder: (_) => const Birdquiz()),
    _QuizItem(moduleKey: 'flowers',   label: 'Flower quiz',    image: 'assets/images/Flowers.png',  builder: (_) => const Flowerquiz()),
    _QuizItem(moduleKey: 'fruits',    label: 'Fruit quiz',     image: 'assets/images/Fruit.png',    builder: (_) => const Fruitquiz()),
    _QuizItem(moduleKey: 'months',    label: 'Month quiz',     image: 'assets/images/Month.png',    builder: (_) => const Monthquiz()),
    _QuizItem(moduleKey: 'vegetables',label: 'Vegetable quiz', image: 'assets/images/Vegitable.png',builder: (_) => const Vegitablequiz()),
  ];

  @override
  void initState() {
    super.initState();
    _loadUnlocks();
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

  void _onLocked(String moduleKey, bool isParentLocked) {
    HapticFeedback.heavyImpact();
    
    String message;
    if (isParentLocked) {
      message = 'This activity is locked by your parent! 🔒';
    } else {
      final prereq = UnlockService.instance.prerequisiteFor(moduleKey);
      message = 'Finish "$prereq" first to unlock this! 🚀';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CosmicPalette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CosmicPalette.outline),
        ),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _onUnlockedTap(_QuizItem item) {
    Navigator.push(context, MaterialPageRoute(builder: item.builder))
        .then((_) => _loadUnlocks());
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const _LoadingCosmic();
    }

    final parentLocked = context.watch<AppState>().lockedModules;

    final galleryItems = _items.map((item) {
      final isProgressUnlocked = _unlocked.contains(item.moduleKey);
      final isParentLocked = parentLocked.contains(item.moduleKey);
      final canAccess = isProgressUnlocked && !isParentLocked;

      return CosmicGalleryItem(
        label: item.label,
        image: item.image,
        spoken: canAccess ? item.label : (isParentLocked ? 'Locked by parent' : 'Locked'),
        accentCategory: item.moduleKey,
        enabled: canAccess,
        overlay: canAccess
            ? null
            : Center(
                child: Icon(
                  Icons.lock_rounded,
                  color: isParentLocked ? Colors.red.shade300 : Colors.white70,
                  size: 38,
                ),
              ),
        onTap: canAccess
            ? () => _onUnlockedTap(item)
            : () => _onLocked(item.moduleKey, isParentLocked),
      );
    }).toList();

    return CosmicGalleryScreen(
      title: 'Look and choose',
      subtitle: 'Match the picture to its name',
      category: 'numbers',
      items: galleryItems,
    );
  }
}

class _LoadingCosmic extends StatelessWidget {
  const _LoadingCosmic();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CosmicPalette.bg,
      body: Center(
        child: CircularProgressIndicator(
          color: CosmicPalette.secondary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

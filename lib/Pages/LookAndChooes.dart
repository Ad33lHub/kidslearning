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
import 'package:provider/provider.dart';

class _QuizCategoryItem {
  final String moduleKey;
  final String label;
  final String image;
  final WidgetBuilder builder;
  const _QuizCategoryItem({
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

  static final _items = <_QuizCategoryItem>[
    _QuizCategoryItem(
      moduleKey: 'alphabet',
      label: 'ABC Songs',
      image: 'assets/images/Alphabet.png',
      builder: (_) => const ABCQuiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'numbers',
      label: 'Number Songs',
      image: 'assets/images/Numbers.png',
      builder: (_) => const Numberquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'colors',
      label: 'Color Songs',
      image: 'assets/images/Color.png',
      builder: (_) => const Colorquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'shapes',
      label: 'Shape Songs',
      image: 'assets/images/Shapes.png',
      builder: (_) => const Shapequiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'animals',
      label: 'Animal Songs',
      image: 'assets/images/Animals.png',
      builder: (_) => const AnimalQuiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'birds',
      label: 'Bird Songs',
      image: 'assets/images/Birds.png',
      builder: (_) => const Birdquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'flowers',
      label: 'Flower Songs',
      image: 'assets/images/Flowers.png',
      builder: (_) => const Flowerquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'fruits',
      label: 'Fruit Songs',
      image: 'assets/images/Fruit.png',
      builder: (_) => const Fruitquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'months',
      label: 'Month Songs',
      image: 'assets/images/Month.png',
      builder: (_) => const Monthquiz(),
    ),
    _QuizCategoryItem(
      moduleKey: 'vegetables',
      label: 'Vegetable Songs',
      image: 'assets/images/Vegitable.png',
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
          content: Text(
            'Finish "$prereq" first to unlock this!',
            style: const TextStyle(fontFamily: 'arlrdbd'),
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
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        title: const Center(
          child: Text(
            'Look And Chooes',
            style: TextStyle(color: Colors.black, fontFamily: 'arlrdbd'),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              padding: const EdgeInsets.all(35),
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
              crossAxisCount: 2,
              children: _items.map(_buildTile).toList(),
            ),
    );
  }

  Widget _buildTile(_QuizCategoryItem item) {
    final isUnlocked = _unlocked.contains(item.moduleKey);
    return InkWell(
      onTap: () => _onTapItem(item),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.orange[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: isUnlocked ? 1 : 0.4,
                  child: Image.asset(item.image, height: 90),
                ),
                Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange[100],
                  ),
                  child: Center(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'arlrdbd',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isUnlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.lock, color: Colors.white, size: 48),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

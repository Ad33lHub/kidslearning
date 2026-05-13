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
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:provider/provider.dart';

class LetsStartLearning extends StatelessWidget {
  final int index;
  const LetsStartLearning(this.index, {super.key});

  static const _meta = [
    _CategoryMeta('Alphabet', 'assets/images/Alphabet.png', 'alphabet'),
    _CategoryMeta('Numbers', 'assets/images/Numbers.png', 'numbers'),
    _CategoryMeta('Colors', 'assets/images/Color.png', 'colors'),
    _CategoryMeta('Shapes', 'assets/images/Shapes.png', 'shapes'),
    _CategoryMeta('Animals', 'assets/images/Animals.png', 'animals'),
    _CategoryMeta('Birds', 'assets/images/Birds.png', 'birds'),
    _CategoryMeta('Flowers', 'assets/images/Flowers.png', 'flowers'),
    _CategoryMeta('Fruits', 'assets/images/Fruit.png', 'fruits'),
    _CategoryMeta('Months', 'assets/images/Month.png', 'months'),
    _CategoryMeta('Vegetables', 'assets/images/Vegitable.png', 'vegetables'),
  ];

  Widget _builderFor(int i) {
    switch (i) {
      case 0: return const Alphabet();
      case 1: return const Numbers();
      case 2: return learning_colors.Color(index);
      case 3: return const Shapes();
      case 4: return const Animal();
      case 5: return const Brids();
      case 6: return const Flower();
      case 7: return const Fruits();
      case 8: return Month();
      case 9: return const Vegitable();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().lockedModules;

    final items = List<CosmicGalleryItem>.generate(_meta.length, (i) {
      final m = _meta[i];
      final isLocked = locked.contains(m.key);
      return CosmicGalleryItem(
        label: m.label,
        image: m.image,
        spoken: isLocked ? 'Locked' : m.label,
        accentCategory: m.key,
        enabled: !isLocked,
        overlay: isLocked
            ? const Center(
                child: Icon(
                  Icons.lock_rounded,
                  color: Colors.white70,
                  size: 44,
                ),
              )
            : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _builderFor(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: "Let's start learning",
      subtitle: 'Pick a topic to explore',
      category: 'alphabet',
      items: items,
    );
  }
}

class _CategoryMeta {
  final String label;
  final String image;
  final String key;
  const _CategoryMeta(this.label, this.image, this.key);
}

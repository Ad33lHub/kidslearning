import 'package:flutter/material.dart';
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
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';

class ListenGuess extends StatelessWidget {
  const ListenGuess({super.key});

  static const _items = [
    _ListenMeta('Alphabet',   'assets/images/Alphabet.png', 'alphabet'),
    _ListenMeta('Numbers',    'assets/images/Numbers.png',  'numbers'),
    _ListenMeta('Colors',     'assets/images/Color.png',    'colors'),
    _ListenMeta('Shapes',     'assets/images/Shapes.png',   'shapes'),
    _ListenMeta('Animals',    'assets/images/Animals.png',  'animals'),
    _ListenMeta('Birds',      'assets/images/Birds.png',    'birds'),
    _ListenMeta('Flowers',    'assets/images/Flowers.png',  'flowers'),
    _ListenMeta('Fruits',     'assets/images/Fruit.png',    'fruits'),
    _ListenMeta('Months',     'assets/images/Month.png',    'months'),
    _ListenMeta('Vegetables', 'assets/images/Vegitable.png','vegetables'),
  ];

  Widget _builderFor(int i) {
    switch (i) {
      case 0: return const AlphabetSong();
      case 1: return const NumberSong();
      case 2: return const ColorSong();
      case 3: return const ShapesSong();
      case 4: return const AnimalsSong();
      case 5: return const BirdsSong();
      case 6: return const FlowerSong();
      case 7: return const FruitSong();
      case 8: return const MonthSong();
      case 9: return const VegitableSong();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = List<CosmicGalleryItem>.generate(_items.length, (i) {
      final m = _items[i];
      return CosmicGalleryItem(
        label: m.label,
        image: m.image,
        spoken: m.label,
        accentCategory: m.key,
        badge: '🎧',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _builderFor(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Listen and guess',
      subtitle: 'Hear the word, choose the picture',
      category: 'animals',
      items: items,
    );
  }
}

class _ListenMeta {
  final String label;
  final String image;
  final String key;
  const _ListenMeta(this.label, this.image, this.key);
}

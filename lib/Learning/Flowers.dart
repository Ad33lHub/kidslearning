import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/FlowerSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Flower extends StatelessWidget {
  const Flower({super.key});

  @override
  Widget build(BuildContext context) {
    final list = FLOWERS1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FlowerSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Flowers',
      subtitle: 'Blooms that dance with starlight',
      category: 'flowers',
      items: items,
    );
  }
}

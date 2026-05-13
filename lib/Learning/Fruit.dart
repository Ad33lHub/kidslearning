import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/FruitSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Fruits extends StatelessWidget {
  const Fruits({super.key});

  @override
  Widget build(BuildContext context) {
    final list = fruit1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FruitSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Fruits',
      subtitle: 'Sweet treasures of the orchard',
      category: 'fruits',
      items: items,
    );
  }
}

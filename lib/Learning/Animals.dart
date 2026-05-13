import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/AnimalsSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Animal extends StatelessWidget {
  const Animal({super.key});

  @override
  Widget build(BuildContext context) {
    final list = ANIMAL1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AnimalSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Animals',
      subtitle: 'Meet creatures from across the galaxy',
      category: 'animals',
      items: items,
    );
  }
}

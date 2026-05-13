import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/VegitableSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Vegitable extends StatelessWidget {
  const Vegitable({super.key});

  @override
  Widget build(BuildContext context) {
    final list = vegitable1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VegitableSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Vegetables',
      subtitle: 'Greens from cosmic gardens',
      category: 'vegetables',
      items: items,
    );
  }
}

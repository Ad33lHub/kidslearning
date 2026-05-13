import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ShapeSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Shapes extends StatelessWidget {
  const Shapes({super.key});

  @override
  Widget build(BuildContext context) {
    final list = SHAPE1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ShapeSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Shapes',
      subtitle: 'Discover orbital geometry',
      category: 'shapes',
      items: items,
    );
  }
}

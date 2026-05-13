import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ColorSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Color extends StatelessWidget {
  // Preserved for compatibility with existing call sites — currently
  // unused by the screen itself but consumed by the parent route.
  final int index;
  const Color(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = COLOR1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ColorSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Colors',
      subtitle: 'Paint the cosmos with colours',
      category: 'colors',
      items: items,
    );
  }
}

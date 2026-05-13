import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/Alphasound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Alphabet extends StatelessWidget {
  const Alphabet({super.key});

  @override
  Widget build(BuildContext context) {
    final list = KidsList1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AlphaSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Alphabet',
      subtitle: 'Tap a letter to hear it',
      category: 'alphabet',
      items: items,
    );
  }
}

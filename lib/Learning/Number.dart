import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/NumberSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Numbers extends StatelessWidget {
  const Numbers({super.key});

  @override
  Widget build(BuildContext context) {
    final list = NumberList();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        image2: m.image2.isNotEmpty ? m.image2 : null,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NumberSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Numbers',
      subtitle: 'Count along with the stars',
      category: 'numbers',
      items: items,
    );
  }
}

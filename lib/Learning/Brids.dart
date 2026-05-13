import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/BridSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Brids extends StatelessWidget {
  const Brids({super.key});

  @override
  Widget build(BuildContext context) {
    final list = BRIDS1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BridSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Birds',
      subtitle: 'Sky-dwellers of every feather',
      category: 'birds',
      items: items,
    );
  }
}

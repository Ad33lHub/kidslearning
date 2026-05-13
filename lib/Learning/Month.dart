import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/MonthSound.dart';
import 'package:kids/core/widgets/cosmic_gallery_screen.dart';
import 'package:kids/utils/model.dart';

class Month extends StatelessWidget {
  Month({super.key});

  @override
  Widget build(BuildContext context) {
    final list = month1();
    final items = List<CosmicGalleryItem>.generate(list.length, (i) {
      final m = list[i];
      return CosmicGalleryItem(
        label: m.Text,
        image: m.image,
        spoken: m.Text,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MonthSound(i)),
        ),
      );
    });

    return CosmicGalleryScreen(
      title: 'Months',
      subtitle: 'Travel through the year',
      category: 'months',
      items: items,
    );
  }
}

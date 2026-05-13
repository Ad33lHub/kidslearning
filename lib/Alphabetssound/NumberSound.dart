import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_item_viewer.dart';
import 'package:kids/utils/model.dart';

class NumberSound extends StatelessWidget {
  final int index1;
  const NumberSound(this.index1, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = NumberList();
    return CosmicItemViewer(
      title: 'Numbers',
      category: 'numbers',
      initialIndex: index1,
      items: list.map((m) {
        return CosmicItemEntry(
          image: m.image,
          secondaryImage: m.image2.isNotEmpty ? m.image2 : null,
          label: m.Text,
        );
      }).toList(),
    );
  }
}

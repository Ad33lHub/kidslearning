import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_item_viewer.dart';
import 'package:kids/utils/model.dart';

class FruitSound extends StatelessWidget {
  final int index1;
  const FruitSound(this.index1, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = fruit1();
    return CosmicItemViewer(
      title: 'Fruits',
      category: 'fruits',
      initialIndex: index1,
      items: list
          .map((m) => CosmicItemEntry(image: m.image, label: m.Text))
          .toList(),
    );
  }
}

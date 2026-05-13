import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_item_viewer.dart';
import 'package:kids/utils/model.dart';

class ShapeSound extends StatelessWidget {
  final int index1;
  const ShapeSound(this.index1, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = SHAPE1();
    return CosmicItemViewer(
      title: 'Shapes',
      category: 'shapes',
      initialIndex: index1,
      items: list
          .map((m) => CosmicItemEntry(image: m.image, label: m.Text))
          .toList(),
    );
  }
}

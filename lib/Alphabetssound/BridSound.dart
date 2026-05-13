import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_item_viewer.dart';
import 'package:kids/utils/model.dart';

class BridSound extends StatelessWidget {
  final int index1;
  const BridSound(this.index1, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = BRIDS1();
    return CosmicItemViewer(
      title: 'Birds',
      category: 'birds',
      initialIndex: index1,
      items: list
          .map((m) => CosmicItemEntry(image: m.image, label: m.Text))
          .toList(),
    );
  }
}

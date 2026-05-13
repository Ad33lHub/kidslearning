import 'package:flutter/material.dart';

import 'cosmic_app_bar.dart';
import 'cosmic_background.dart';
import 'cosmic_theme.dart';

/// Standard scaffold for every learning screen: cosmic animated background
/// + glass app bar. Pass the page content as [child]. The body is wrapped in
/// [SafeArea] so platform insets don't clash with the glass app bar.
class CosmicScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final Color accent;
  final List<Widget> actions;
  final bool withSafeArea;
  final FloatingActionButton? floatingActionButton;

  const CosmicScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.accent = CosmicPalette.secondary,
    this.actions = const [],
    this.withSafeArea = true,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicPalette.bg,
      extendBodyBehindAppBar: true,
      floatingActionButton: floatingActionButton,
      body: CosmicBackground(
        accentNebula: accent,
        child: Column(
          children: [
            CosmicAppBar(
              title: title,
              subtitle: subtitle,
              accent: accent,
              actions: actions,
            ),
            Expanded(
              child: withSafeArea
                  ? SafeArea(top: false, child: child)
                  : child,
            ),
          ],
        ),
      ),
    );
  }
}

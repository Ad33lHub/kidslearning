import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/audio_guidance_service.dart';
import 'cosmic_card.dart';
import 'cosmic_scaffold.dart';
import 'cosmic_theme.dart';

class CosmicGalleryItem {
  final String label;
  final String? image;
  final String? image2;
  final String? emoji;
  final String? spoken;
  final VoidCallback onTap;

  /// Per-item override for the accent (top color in gradient + halo).
  /// Null falls back to the screen's [CosmicGalleryScreen.category].
  final String? accentCategory;

  /// Optional small badge shown top-right (defaults to category emoji).
  final String? badge;

  /// When false the card renders dimmed and disables taps.
  final bool enabled;

  /// Overlay (e.g. lock icon) placed over the card when not enabled.
  final Widget? overlay;

  const CosmicGalleryItem({
    required this.label,
    this.image,
    this.image2,
    this.emoji,
    this.spoken,
    this.accentCategory,
    this.badge,
    this.enabled = true,
    this.overlay,
    required this.onTap,
  });
}

/// Full-screen cosmic gallery — used for:
/// - The 3 mode hubs (Let's Start Learning, Look And Choose, Listen And Guess)
/// - The 10 per-category Learning grids (Animals, Birds, Alphabet, ...)
///
/// Each tile is a [CosmicCard] with a staggered float phase. Tap plays a soft
/// click + optional TTS pronunciation before invoking the item's [onTap].
class CosmicGalleryScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String category;
  final List<CosmicGalleryItem> items;
  final int crossAxisCount;
  final double childAspectRatio;

  const CosmicGalleryScreen({
    super.key,
    required this.title,
    required this.items,
    this.subtitle,
    this.category = 'alphabet',
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.92,
  });

  void _onItemTap(CosmicGalleryItem item) {
    HapticFeedback.lightImpact();
    SystemSound.play(SystemSoundType.click);
    if (item.spoken != null) {
      AudioGuidanceService.instance.speak(item.spoken!);
    }
    item.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final accent = CosmicAccent.light(category);
    final glow = CosmicAccent.deep(category);
    final emoji = CosmicAccent.emoji(category);

    return CosmicScaffold(
      title: title,
      subtitle: subtitle,
      accent: accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossCount = constraints.maxWidth > 600
              ? 3
              : crossAxisCount;
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              final itemAccent = item.accentCategory != null
                  ? CosmicAccent.light(item.accentCategory!)
                  : accent;
              final itemGlow = item.accentCategory != null
                  ? CosmicAccent.deep(item.accentCategory!)
                  : glow;
              final itemBadge = item.badge ??
                  (item.accentCategory != null
                      ? CosmicAccent.emoji(item.accentCategory!)
                      : emoji);
              final card = CosmicCard(
                accent: itemAccent,
                glow: itemGlow,
                phase: i * 0.13,
                cornerBadge: itemBadge,
                enabled: item.enabled,
                onTap: () => _onItemTap(item),
                child: _CosmicGalleryTileContent(
                  item: item,
                  accent: itemAccent,
                  glow: itemGlow,
                ),
              );
              if (item.overlay == null) return card;
              return Stack(
                fit: StackFit.expand,
                children: [
                  card,
                  IgnorePointer(child: item.overlay!),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CosmicGalleryTileContent extends StatelessWidget {
  final CosmicGalleryItem item;
  final Color accent;
  final Color glow;

  const _CosmicGalleryTileContent({
    required this.item,
    required this.accent,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accent.withOpacity(0.55),
                  accent.withOpacity(0.10),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: glow.withOpacity(0.55),
                  blurRadius: 18,
                ),
              ],
            ),
            child: item.image != null
                ? (item.image2 != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            item.image!,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            item.image2!,
                            height: 48,
                            fit: BoxFit.contain,
                          ),
                        ],
                      )
                    : Image.asset(
                        item.image!,
                        height: 64,
                        fit: BoxFit.contain,
                      ))
                : Text(
                    item.emoji ?? '✨',
                    style: const TextStyle(fontSize: 44),
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: CosmicText.cardLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

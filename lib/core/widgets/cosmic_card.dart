import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'cosmic_theme.dart';

/// Animated glass card used everywhere in the learning flow:
/// - Gallery items (single image + label)
/// - Quiz choice tiles
/// - Mode cards
///
/// Features: floating y-axis oscillation, tap-down scale to 95%, accent
/// outer glow, glassmorphism fill with backdrop blur. Optimised to keep
/// the floating animation cheap (Transform.translate, no rebuilds).
class CosmicCard extends StatefulWidget {
  /// Sin-wave phase offset (0..1). Stagger cards so they don't bob in unison.
  final double phase;
  final Color accent;
  final Color glow;
  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double floatAmplitude;
  final bool enabled;

  /// Optional badge in the top-right corner (a small emoji or icon string).
  final String? cornerBadge;

  const CosmicCard({
    super.key,
    required this.child,
    this.accent = CosmicPalette.secondary,
    this.glow = CosmicPalette.secondaryDeep,
    this.onTap,
    this.phase = 0.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding,
    this.floatAmplitude = 4.0,
    this.enabled = true,
    this.cornerBadge,
  });

  @override
  State<CosmicCard> createState() => _CosmicCardState();
}

class _CosmicCardState extends State<CosmicCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = AnimatedScale(
      scale: _pressed ? 0.95 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.glow.withOpacity(
                widget.enabled ? (_pressed ? 0.55 : 0.30) : 0.10,
              ),
              blurRadius: _pressed ? 22 : 16,
              spreadRadius: _pressed ? 1 : 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.accent.withOpacity(0.22),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
                border: Border.all(color: CosmicPalette.outline, width: 1),
              ),
              child: Stack(
                children: [
                  if (widget.cornerBadge != null)
                    Positioned(
                      top: 8,
                      right: 10,
                      child: Text(
                        widget.cornerBadge!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.accent.withOpacity(0.10),
                      ),
                    ),
                  ),
                  widget.child,
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (_, child) {
        final dy = math.sin(
              (_floatCtrl.value + widget.phase) * math.pi * 2,
            ) *
            widget.floatAmplitude;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: GestureDetector(
        onTapDown: widget.enabled
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapCancel: widget.enabled
            ? () => setState(() => _pressed = false)
            : null,
        onTapUp: widget.enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        onTap: widget.enabled ? widget.onTap : null,
        child: card,
      ),
    );
  }
}

/// Default content used inside CosmicCard for a gallery tile:
/// circular glowing image holder + bold label + optional subtitle.
class CosmicCardContent extends StatelessWidget {
  final String? image;
  final String? emoji;
  final String label;
  final String? subtitle;
  final Color accent;
  final Color glow;
  final double imageHeight;

  const CosmicCardContent({
    super.key,
    this.image,
    this.emoji,
    required this.label,
    this.subtitle,
    this.accent = CosmicPalette.secondary,
    this.glow = CosmicPalette.secondaryDeep,
    this.imageHeight = 64,
  }) : assert(image != null || emoji != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
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
            child: image != null
                ? Image.asset(
                    image!,
                    height: imageHeight,
                    fit: BoxFit.contain,
                  )
                : Text(
                    emoji!,
                    style: TextStyle(fontSize: imageHeight * 0.7),
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: CosmicText.cardLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: CosmicText.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/audio_guidance_service.dart';
import 'cosmic_scaffold.dart';
import 'cosmic_theme.dart';

/// Cosmic pronunciation viewer — used by every per-item detail screen
/// (Alphabetssound/*). Shows a single large floating card with the item's
/// image, the pronunciation text, a big speaker button (taps TTS-speak),
/// and prev/next pill buttons.
///
/// Audio is routed through [AudioGuidanceService] so overlapping speech
/// is impossible: each speak() stops the previous utterance first.
class CosmicItemViewer extends StatefulWidget {
  final String title;
  final String category;
  final List<CosmicItemEntry> items;
  final int initialIndex;

  const CosmicItemViewer({
    super.key,
    required this.title,
    required this.category,
    required this.items,
    this.initialIndex = 0,
  });

  @override
  State<CosmicItemViewer> createState() => _CosmicItemViewerState();
}

class CosmicItemEntry {
  final String image;
  final String? secondaryImage;
  final String label;

  const CosmicItemEntry({
    required this.image,
    this.secondaryImage,
    required this.label,
  });
}

class _CosmicItemViewerState extends State<CosmicItemViewer>
    with SingleTickerProviderStateMixin {
  late int _index;
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.items.length - 1);
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    AudioGuidanceService.instance.stop();
    super.dispose();
  }

  void _speakCurrent() {
    final item = widget.items[_index];
    AudioGuidanceService.instance.speak(item.label);
  }

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.items.length - 1);
    if (next == _index) return;
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
    setState(() => _index = next);
    _speakCurrent();
  }

  void _onSpeakerTap() {
    HapticFeedback.lightImpact();
    _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final accent = CosmicAccent.light(widget.category);
    final glow = CosmicAccent.deep(widget.category);
    final item = widget.items[_index];
    final isFirst = _index == 0;
    final isLast = _index == widget.items.length - 1;

    return CosmicScaffold(
      title: widget.title,
      subtitle: '${_index + 1} of ${widget.items.length}',
      accent: accent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showLarge = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                Expanded(
                  child: _FloatingImageCard(
                    image: item.image,
                    secondaryImage: item.secondaryImage,
                    accent: accent,
                    glow: glow,
                    floatCtrl: _floatCtrl,
                  ),
                ),
                const SizedBox(height: 12),
                _PronunciationStrip(label: item.label),
                const SizedBox(height: 16),
                _SpeakerButton(
                  onTap: _onSpeakerTap,
                  accent: accent,
                  glow: glow,
                  big: showLarge,
                ),
                const SizedBox(height: 16),
                _NavRow(
                  onPrev: isFirst ? null : () => _go(-1),
                  onNext: isLast ? null : () => _go(1),
                  accent: accent,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FloatingImageCard extends StatelessWidget {
  final String image;
  final String? secondaryImage;
  final Color accent;
  final Color glow;
  final AnimationController floatCtrl;

  const _FloatingImageCard({
    required this.image,
    required this.secondaryImage,
    required this.accent,
    required this.glow,
    required this.floatCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatCtrl,
      builder: (_, child) {
        final dy = math.sin(floatCtrl.value * math.pi * 2) * 8;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: glow.withOpacity(0.45),
              blurRadius: 36,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent.withOpacity(0.22),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
                border: Border.all(color: CosmicPalette.outline, width: 1),
              ),
              child: Center(
                child: secondaryImage != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Image.asset(image, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Image.asset(
                              secondaryImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      )
                    : Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PronunciationStrip extends StatelessWidget {
  final String label;
  const _PronunciationStrip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CosmicPalette.outline),
      ),
      child: Text(
        label,
        style: CosmicText.pronunciation,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SpeakerButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color accent;
  final Color glow;
  final bool big;

  const _SpeakerButton({
    required this.onTap,
    required this.accent,
    required this.glow,
    this.big = false,
  });

  @override
  State<_SpeakerButton> createState() => _SpeakerButtonState();
}

class _SpeakerButtonState extends State<_SpeakerButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final size = widget.big ? 88.0 : 72.0;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.accent.withOpacity(0.85),
                widget.accent.withOpacity(0.25),
              ],
            ),
            border: Border.all(color: CosmicPalette.outlineStrong, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: widget.glow.withOpacity(_pressed ? 0.85 : 0.55),
                blurRadius: _pressed ? 32 : 22,
                spreadRadius: _pressed ? 2 : 0,
              ),
            ],
          ),
          child: const Icon(
            Icons.volume_up_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final Color accent;

  const _NavRow({
    required this.onPrev,
    required this.onNext,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PillButton(
            label: 'Previous',
            icon: Icons.arrow_back_rounded,
            accent: accent,
            onTap: onPrev,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PillButton(
            label: 'Next',
            icon: Icons.arrow_forward_rounded,
            accent: accent,
            onTap: onNext,
            trailing: true,
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  final bool trailing;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
    this.trailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: disabled ? 0.35 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.32),
                accent.withOpacity(0.12),
              ],
            ),
            border: Border.all(color: CosmicPalette.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: trailing
                ? [
                    Text(label, style: CosmicText.body),
                    const SizedBox(width: 6),
                    Icon(icon, color: Colors.white, size: 18),
                  ]
                : [
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(label, style: CosmicText.body),
                  ],
          ),
        ),
      ),
    );
  }
}

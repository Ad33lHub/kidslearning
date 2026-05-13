import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'cosmic_theme.dart';

/// Translucent glass app bar that sits above the cosmic background.
/// Provides a circular back button + centered title. Tap on back plays
/// a haptic + system click for tactile feedback.
class CosmicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Color accent;

  const CosmicAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.accent = CosmicPalette.secondary,
  });

  @override
  Size get preferredSize => const Size.fromHeight(76);

  void _handleBack(BuildContext context) {
    HapticFeedback.selectionClick();
    SystemSound.play(SystemSoundType.click);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, mq.padding.top + 8, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            border: const Border(
              bottom: BorderSide(color: CosmicPalette.outline),
            ),
          ),
          child: Row(
            children: [
              _GlassIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => _handleBack(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (r) => LinearGradient(
                        colors: [accent, Colors.white],
                      ).createShader(r),
                      child: Text(
                        title,
                        style: CosmicText.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: CosmicText.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: CosmicPalette.outline),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

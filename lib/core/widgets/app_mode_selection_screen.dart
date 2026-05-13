import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_background.dart';
import 'package:kids/core/widgets/cosmic_card.dart';
import 'package:kids/core/widgets/cosmic_theme.dart';

enum AppMode { parent, children }

class AppModeSelectionScreen extends StatelessWidget {
  final Function(AppMode) onSelected;

  const AppModeSelectionScreen({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CosmicPalette.bg,
      body: CosmicBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [CosmicPalette.secondary, Colors.white],
                  ).createShader(bounds),
                  child: const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Who is using the app today?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: CosmicCard(
                        onTap: () => onSelected(AppMode.children),
                        accent: CosmicPalette.teal,
                        glow: CosmicPalette.tealDeep,
                        child: const _ModeItem(
                          icon: '👶',
                          label: 'Children',
                          description: 'Play & Learn',
                          color: CosmicPalette.teal,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CosmicCard(
                        onTap: () => onSelected(AppMode.parent),
                        accent: CosmicPalette.secondary,
                        glow: CosmicPalette.secondaryDeep,
                        phase: 0.5,
                        child: const _ModeItem(
                          icon: '🛡️',
                          label: 'Parent',
                          description: 'Manage & Track',
                          color: CosmicPalette.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                Text(
                  'Premium Learning Experience',
                  style: CosmicText.caption.copyWith(color: Colors.white38),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeItem extends StatelessWidget {
  final String icon;
  final String label;
  final String description;
  final Color color;

  const _ModeItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              border: Border.all(color: color.withOpacity(0.3), width: 2),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

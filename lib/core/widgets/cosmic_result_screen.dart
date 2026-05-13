import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../db/badges_repository.dart';
import '../providers/app_state.dart';
import '../services/quiz_completion_service.dart';
import 'cosmic_scaffold.dart';
import 'cosmic_theme.dart';

/// Drop-in replacement for the legacy ResultSrceen — keeps the persistence
/// behaviour (records the score, awards stars/coins, surfaces new badges)
/// but renders the cosmic glass aesthetic.
class CosmicResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String category;

  const CosmicResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.category,
  });

  @override
  State<CosmicResultScreen> createState() => _CosmicResultScreenState();
}

class _CosmicResultScreenState extends State<CosmicResultScreen> {
  QuizCompletionResult? _result;
  bool _saving = true;

  @override
  void initState() {
    super.initState();
    _persistScore();
  }

  Future<void> _persistScore() async {
    final childId = context.read<AppState>().currentChild?.id;
    final result = await QuizCompletionService.instance.record(
      childId: childId,
      category: widget.category,
      score: widget.score,
      total: widget.total,
    );
    if (mounted) {
      setState(() {
        _result = result;
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = CosmicAccent.light(widget.category);
    final glow = CosmicAccent.deep(widget.category);
    final result = _result;

    return CosmicScaffold(
      title: 'Quiz Result',
      accent: accent,
      child: _saving || result == null
          ? const Center(
              child: CircularProgressIndicator(
                color: CosmicPalette.secondary,
                strokeWidth: 3,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ShaderMask(
                    shaderCallback: (r) => LinearGradient(
                      colors: [accent, Colors.white, CosmicPalette.teal],
                    ).createShader(r),
                    child: const Text(
                      'Stellar work! 🎉',
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Your score', style: CosmicText.caption),
                  const SizedBox(height: 8),
                  _ScoreCard(
                    score: result.score,
                    total: result.total,
                    accent: accent,
                    glow: glow,
                  ),
                  const SizedBox(height: 24),
                  _StarsRow(stars: result.starsAwarded),
                  const SizedBox(height: 16),
                  _RewardChips(result: result),
                  if (result.newBadges.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _NewBadges(keys: result.newBadges),
                  ],
                  const SizedBox(height: 32),
                  _HomeButton(accent: accent, glow: glow),
                ],
              ),
            ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final int score;
  final int total;
  final Color accent;
  final Color glow;

  const _ScoreCard({
    required this.score,
    required this.total,
    required this.accent,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.22),
                Colors.white.withOpacity(0.04),
              ],
            ),
            border: Border.all(color: CosmicPalette.outline),
            boxShadow: [
              BoxShadow(color: glow.withOpacity(0.45), blurRadius: 24),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 72,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  ' / $total',
                  style: CosmicText.heading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarsRow extends StatelessWidget {
  final int stars;
  const _StarsRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final filled = i < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Container(
            decoration: filled
                ? const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: CosmicPalette.tertiary,
                        blurRadius: 18,
                      ),
                    ],
                  )
                : null,
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              color: filled ? CosmicPalette.tertiary : CosmicPalette.outline,
              size: 56,
            ),
          ),
        );
      }),
    );
  }
}

class _RewardChips extends StatelessWidget {
  final QuizCompletionResult result;
  const _RewardChips({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chip('⭐ +${result.starsAwarded}'),
        const SizedBox(width: 12),
        _chip('🪙 +${result.coinsAwarded}'),
      ],
    );
  }

  Widget _chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: CosmicPalette.outline),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      );
}

class _NewBadges extends StatelessWidget {
  final List<String> keys;
  const _NewBadges({required this.keys});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'New badges unlocked!',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: keys.map((k) {
            final meta = BadgeCatalog.meta[k];
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: CosmicPalette.outline),
              ),
              child: Text(
                '${meta?['emoji'] ?? '🏅'}  ${meta?['label'] ?? k}',
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _HomeButton extends StatelessWidget {
  final Color accent;
  final Color glow;
  const _HomeButton({required this.accent, required this.glow});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        SystemSound.play(SystemSoundType.click);
        Navigator.of(context).popUntil((r) => r.isFirst);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [accent, glow],
          ),
          boxShadow: [
            BoxShadow(color: glow.withOpacity(0.55), blurRadius: 22),
          ],
        ),
        child: const Text(
          'Back to Home',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

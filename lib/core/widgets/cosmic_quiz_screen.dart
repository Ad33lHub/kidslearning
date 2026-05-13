import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/audio_guidance_service.dart';
import 'cosmic_scaffold.dart';
import 'cosmic_theme.dart';

enum CosmicChoiceType { text, image }

/// Defines a single quiz question — a prompt + list of choices.
class CosmicQuizQuestion {
  /// The prompt shown above the choices. For "Quiz" mode: usually an image
  /// asset path. For "Listen And Guess" mode: usually a word (spoken).
  final String? promptImage;
  final String? promptText;

  /// What TTS should speak when the question first appears or when the
  /// user taps the speaker button. Null disables auto-speak for this q.
  final String? speakOnEnter;

  /// The list of choices. Order is significant.
  final List<CosmicChoice> choices;

  const CosmicQuizQuestion({
    this.promptImage,
    this.promptText,
    this.speakOnEnter,
    required this.choices,
  });
}

class CosmicChoice {
  /// For text choices, the label shown. For image choices, the asset path.
  final String value;
  final bool correct;

  const CosmicChoice(this.value, {required this.correct});
}

typedef CosmicQuizDoneCallback = void Function(int score, int total);

/// Reusable quiz screen used by every Quiz/* and ListenGuessSongs/* file.
/// Preserves existing scoring behaviour while providing the cosmic UI.
class CosmicQuizScreen extends StatefulWidget {
  final String title;
  final String category;
  final CosmicChoiceType choiceType;
  final List<CosmicQuizQuestion> questions;
  final CosmicQuizDoneCallback? onCompleted;

  const CosmicQuizScreen({
    super.key,
    required this.title,
    required this.category,
    required this.choiceType,
    required this.questions,
    this.onCompleted,
  });

  @override
  State<CosmicQuizScreen> createState() => _CosmicQuizScreenState();
}

class _CosmicQuizScreenState extends State<CosmicQuizScreen> {
  final PageController _controller = PageController();
  int _index = 0;
  int? _selectedChoice;
  bool _answered = false;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  @override
  void dispose() {
    _controller.dispose();
    AudioGuidanceService.instance.stop();
    super.dispose();
  }

  void _speakCurrent() {
    final q = widget.questions[_index];
    if (q.speakOnEnter != null) {
      AudioGuidanceService.instance.speak(q.speakOnEnter!);
    }
  }

  void _onChoiceTap(int i) {
    if (_answered) return;
    HapticFeedback.lightImpact();
    final q = widget.questions[_index];
    final correct = q.choices[i].correct;
    setState(() {
      _selectedChoice = i;
      _answered = true;
      if (correct) _score += 1;
    });
    SystemSound.play(SystemSoundType.click);
    if (!correct) HapticFeedback.heavyImpact();
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_index + 1 == widget.questions.length) {
      AudioGuidanceService.instance.stop();
      widget.onCompleted?.call(_score, widget.questions.length);
      return;
    }
    setState(() {
      _index += 1;
      _answered = false;
      _selectedChoice = null;
    });
    _controller.animateToPage(
      _index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
    _speakCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final accent = CosmicAccent.light(widget.category);
    final glow = CosmicAccent.deep(widget.category);
    final total = widget.questions.length;

    return CosmicScaffold(
      title: widget.title,
      subtitle: 'Question ${_index + 1} of $total · Score $_score',
      accent: accent,
      child: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: total,
        itemBuilder: (context, i) {
          final q = widget.questions[i];
          return _QuestionBody(
            question: q,
            accent: accent,
            glow: glow,
            choiceType: widget.choiceType,
            selectedIndex: _selectedChoice,
            answered: _answered,
            onChoiceTap: _onChoiceTap,
            onSpeak: () {
              HapticFeedback.lightImpact();
              if (q.speakOnEnter != null) {
                AudioGuidanceService.instance.speak(q.speakOnEnter!);
              }
            },
            onNext: _answered ? _next : null,
            isLast: i + 1 == total,
            progress: (i + 1) / total,
          );
        },
      ),
    );
  }
}

class _QuestionBody extends StatelessWidget {
  final CosmicQuizQuestion question;
  final Color accent;
  final Color glow;
  final CosmicChoiceType choiceType;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onChoiceTap;
  final VoidCallback onSpeak;
  final VoidCallback? onNext;
  final bool isLast;
  final double progress;

  const _QuestionBody({
    required this.question,
    required this.accent,
    required this.glow,
    required this.choiceType,
    required this.selectedIndex,
    required this.answered,
    required this.onChoiceTap,
    required this.onSpeak,
    required this.onNext,
    required this.isLast,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: [
          _ProgressBar(value: progress, accent: accent, glow: glow),
          const SizedBox(height: 16),
          _PromptCard(
            question: question,
            accent: accent,
            glow: glow,
            onSpeak: onSpeak,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: question.choices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: choiceType == CosmicChoiceType.text
                    ? 1.7
                    : 1.0,
              ),
              itemBuilder: (context, i) => _ChoiceTile(
                choice: question.choices[i],
                accent: accent,
                glow: glow,
                choiceType: choiceType,
                selected: selectedIndex == i,
                revealed: answered,
                onTap: () => onChoiceTap(i),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _NextButton(
            accent: accent,
            glow: glow,
            onTap: onNext,
            isLast: isLast,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final Color accent;
  final Color glow;

  const _ProgressBar({
    required this.value,
    required this.accent,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: CosmicPalette.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, CosmicPalette.teal],
                ),
                boxShadow: [
                  BoxShadow(color: glow.withOpacity(0.6), blurRadius: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PromptCard extends StatelessWidget {
  final CosmicQuizQuestion question;
  final Color accent;
  final Color glow;
  final VoidCallback onSpeak;

  const _PromptCard({
    required this.question,
    required this.accent,
    required this.glow,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.22),
                Colors.white.withOpacity(0.04),
              ],
            ),
            border: Border.all(color: CosmicPalette.outline, width: 1),
            boxShadow: [
              BoxShadow(color: glow.withOpacity(0.25), blurRadius: 18),
            ],
          ),
          child: Row(
            children: [
              if (question.promptImage != null)
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accent.withOpacity(0.55),
                        accent.withOpacity(0.10),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(color: glow.withOpacity(0.55), blurRadius: 18),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    question.promptImage!,
                    fit: BoxFit.contain,
                  ),
                )
              else
                GestureDetector(
                  onTap: onSpeak,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accent.withOpacity(0.85),
                          accent.withOpacity(0.25),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: glow.withOpacity(0.65),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question.promptImage != null
                          ? 'What is this?'
                          : 'What did you hear?',
                      style: CosmicText.caption,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      question.promptText ?? 'Pick the correct one',
                      style: CosmicText.heading,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (question.promptText == null &&
                        question.promptImage == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Tap the speaker to listen again',
                        style: CosmicText.caption,
                      ),
                    ],
                  ],
                ),
              ),
              if (question.promptImage != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onSpeak,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                      border: Border.all(color: CosmicPalette.outline),
                    ),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final CosmicChoice choice;
  final Color accent;
  final Color glow;
  final CosmicChoiceType choiceType;
  final bool selected;
  final bool revealed;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.choice,
    required this.accent,
    required this.glow,
    required this.choiceType,
    required this.selected,
    required this.revealed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color fillTop;
    final Color fillBottom;
    final Color glowColor;

    if (revealed && choice.correct) {
      borderColor = CosmicPalette.correct;
      fillTop = CosmicPalette.correct.withOpacity(0.45);
      fillBottom = CosmicPalette.correct.withOpacity(0.10);
      glowColor = CosmicPalette.correct;
    } else if (revealed && selected && !choice.correct) {
      borderColor = CosmicPalette.wrong;
      fillTop = CosmicPalette.wrong.withOpacity(0.45);
      fillBottom = CosmicPalette.wrong.withOpacity(0.10);
      glowColor = CosmicPalette.wrong;
    } else {
      borderColor = CosmicPalette.outline;
      fillTop = accent.withOpacity(0.22);
      fillBottom = Colors.white.withOpacity(0.04);
      glowColor = glow;
    }

    return GestureDetector(
      onTap: revealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(revealed ? 0.45 : 0.20),
              blurRadius: revealed ? 22 : 14,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [fillTop, fillBottom],
                ),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              padding: const EdgeInsets.all(12),
              child: Center(
                child: choiceType == CosmicChoiceType.text
                    ? Text(
                        choice.value,
                        textAlign: TextAlign.center,
                        style: CosmicText.heading,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : Image.asset(choice.value, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final Color accent;
  final Color glow;
  final VoidCallback? onTap;
  final bool isLast;

  const _NextButton({
    required this.accent,
    required this.glow,
    required this.onTap,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: disabled ? 0.40 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [accent.withOpacity(0.85), glow],
              ),
              boxShadow: disabled
                  ? []
                  : [BoxShadow(color: glow.withOpacity(0.5), blurRadius: 18)],
            ),
            child: Center(
              child: Text(
                isLast ? 'See Result' : 'Next Question',
                style: CosmicText.heading,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

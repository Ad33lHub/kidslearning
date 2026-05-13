import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class AlphabetSong extends StatelessWidget {
  const AlphabetSong({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = abcsongs();
    final qs = List<CosmicQuizQuestion>.generate(alphasongs2.length, (i) {
      final q = alphasongs2[i];
      final word = i < prompts.length ? prompts[i].Text : null;
      return CosmicQuizQuestion(
        promptText: word,
        speakOnEnter: word,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'Alphabet · listen',
      category: 'alphabet',
      choiceType: CosmicChoiceType.image,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'alphabet',
          ),
        ),
      ),
    );
  }
}

/// Legacy alias preserved because some ListenGuessSongs/* files imported
/// `ResultSrceen` from this module.
class ResultSrceen extends StatelessWidget {
  final int score;
  const ResultSrceen(this.score, {super.key});

  @override
  Widget build(BuildContext context) {
    return CosmicResultScreen(
      score: score,
      total: alphasongs2.length,
      category: 'alphabet',
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class ABCQuiz extends StatelessWidget {
  const ABCQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    final images = KidsList1();
    final qs = List<CosmicQuizQuestion>.generate(questions.length, (i) {
      final q = questions[i];
      return CosmicQuizQuestion(
        promptImage: i < images.length ? images[i].image : null,
        speakOnEnter: i < images.length ? images[i].Text : null,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'ABC quiz',
      category: 'alphabet',
      choiceType: CosmicChoiceType.text,
      questions: qs,
      onCompleted: (score, total) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CosmicResultScreen(
              score: score,
              total: total,
              category: 'alphabet',
            ),
          ),
        );
      },
    );
  }
}

/// Legacy alias — some existing files import `ResultSrceen` from this file.
/// Routed to the cosmic result screen for visual consistency.
class ResultSrceen extends StatelessWidget {
  final int score;
  final String category;
  final int total;

  const ResultSrceen(
    this.score, {
    super.key,
    this.category = 'alphabet',
    this.total = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CosmicResultScreen(
      score: score,
      total: total > 0 ? total : questions.length,
      category: category,
    );
  }
}

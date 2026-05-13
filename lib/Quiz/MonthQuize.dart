import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class Monthquiz extends StatelessWidget {
  const Monthquiz({super.key});

  @override
  Widget build(BuildContext context) {
    final images = month1();
    final qs = List<CosmicQuizQuestion>.generate(monthquestion.length, (i) {
      final q = monthquestion[i];
      return CosmicQuizQuestion(
        promptImage: i < images.length ? images[i].image : null,
        speakOnEnter: i < images.length ? images[i].Text : null,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'Month quiz',
      category: 'months',
      choiceType: CosmicChoiceType.text,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'months',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class Birdquiz extends StatelessWidget {
  const Birdquiz({super.key});

  @override
  Widget build(BuildContext context) {
    final images = BRIDS1();
    final qs = List<CosmicQuizQuestion>.generate(birdquestion.length, (i) {
      final q = birdquestion[i];
      return CosmicQuizQuestion(
        promptImage: i < images.length ? images[i].image : null,
        speakOnEnter: i < images.length ? images[i].Text : null,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'Bird quiz',
      category: 'birds',
      choiceType: CosmicChoiceType.text,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'birds',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class Vegitablequiz extends StatelessWidget {
  const Vegitablequiz({super.key});

  @override
  Widget build(BuildContext context) {
    final images = vegitable1();
    final qs = List<CosmicQuizQuestion>.generate(vegitablequestion.length, (i) {
      final q = vegitablequestion[i];
      return CosmicQuizQuestion(
        promptImage: i < images.length ? images[i].image : null,
        speakOnEnter: i < images.length ? images[i].Text : null,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'Vegetable quiz',
      category: 'vegetables',
      choiceType: CosmicChoiceType.text,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'vegetables',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class VegitableSong extends StatelessWidget {
  const VegitableSong({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = vegitable1();
    final qs = List<CosmicQuizQuestion>.generate(vegitablesongs2.length, (i) {
      final q = vegitablesongs2[i];
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
      title: 'Vegetables · listen',
      category: 'vegetables',
      choiceType: CosmicChoiceType.image,
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

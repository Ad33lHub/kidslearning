import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class NumberSong extends StatelessWidget {
  const NumberSong({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = numbersongs();
    final qs = List<CosmicQuizQuestion>.generate(numbersongs2.length, (i) {
      final q = numbersongs2[i];
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
      title: 'Numbers · listen',
      category: 'numbers',
      choiceType: CosmicChoiceType.image,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'numbers',
          ),
        ),
      ),
    );
  }
}

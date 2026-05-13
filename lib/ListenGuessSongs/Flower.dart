import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class FlowerSong extends StatelessWidget {
  const FlowerSong({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = FLOWERS1();
    final qs = List<CosmicQuizQuestion>.generate(flowerssongs2.length, (i) {
      final q = flowerssongs2[i];
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
      title: 'Flowers · listen',
      category: 'flowers',
      choiceType: CosmicChoiceType.image,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'flowers',
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/widgets/cosmic_quiz_screen.dart';
import 'package:kids/core/widgets/cosmic_result_screen.dart';
import 'package:kids/utils/model.dart';

class AnimalQuiz extends StatelessWidget {
  const AnimalQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    final images = ANIMAL1();
    final qs = List<CosmicQuizQuestion>.generate(animalquestion.length, (i) {
      final q = animalquestion[i];
      return CosmicQuizQuestion(
        promptImage: i < images.length ? images[i].image : null,
        speakOnEnter: i < images.length ? images[i].Text : null,
        choices: q.answer.entries
            .map((e) => CosmicChoice(e.key, correct: e.value))
            .toList(),
      );
    });

    return CosmicQuizScreen(
      title: 'Animal quiz',
      category: 'animals',
      choiceType: CosmicChoiceType.text,
      questions: qs,
      onCompleted: (score, total) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CosmicResultScreen(
            score: score,
            total: total,
            category: 'animals',
          ),
        ),
      ),
    );
  }
}

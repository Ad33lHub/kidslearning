import 'package:flutter/material.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/audio_guidance_service.dart';
import 'package:kids/core/services/quiz_completion_service.dart';
import 'package:provider/provider.dart';

class _DragDropQuestion {
  final String prompt;
  final String imageAsset;
  final String correctAnswer;
  final List<String> options;

  const _DragDropQuestion({
    required this.prompt,
    required this.imageAsset,
    required this.correctAnswer,
    required this.options,
  });
}

const _questions = <_DragDropQuestion>[
  _DragDropQuestion(
    prompt: 'Drag the right letter onto the apple',
    imageAsset: 'assets/images/7APPLE.png',
    correctAnswer: 'A',
    options: ['A', 'B', 'C', 'D'],
  ),
  _DragDropQuestion(
    prompt: 'Drag the right letter onto the banana',
    imageAsset: 'assets/images/7BANANA.png',
    correctAnswer: 'B',
    options: ['D', 'B', 'P', 'R'],
  ),
  _DragDropQuestion(
    prompt: 'Drag the right letter onto the cat',
    imageAsset: 'assets/images/1cat.png',
    correctAnswer: 'C',
    options: ['G', 'O', 'C', 'Q'],
  ),
  _DragDropQuestion(
    prompt: 'Drag the right letter onto the dog',
    imageAsset: 'assets/images/1dog.png',
    correctAnswer: 'D',
    options: ['B', 'P', 'D', 'O'],
  ),
  _DragDropQuestion(
    prompt: 'Drag the right letter onto the lion',
    imageAsset: 'assets/images/1lion.png',
    correctAnswer: 'L',
    options: ['I', 'L', 'T', 'F'],
  ),
];

class DragDropQuizScreen extends StatefulWidget {
  const DragDropQuizScreen({super.key});

  @override
  State<DragDropQuizScreen> createState() => _DragDropQuizScreenState();
}

class _DragDropQuizScreenState extends State<DragDropQuizScreen> {
  int _index = 0;
  int _score = 0;
  String? _dropped;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => AudioGuidanceService.instance.speak(
        'Drag the correct letter onto the picture.',
      ),
    );
  }

  @override
  void dispose() {
    AudioGuidanceService.instance.stop();
    super.dispose();
  }

  void _onAccept(String letter) {
    final q = _questions[_index];
    final isCorrect = letter == q.correctAnswer;
    setState(() {
      _dropped = letter;
      _correct = isCorrect;
      if (isCorrect) _score++;
    });
    AudioGuidanceService.instance.speak(
      isCorrect ? 'Correct! Great job!' : 'Try again next time.',
    );
  }

  Future<void> _next() async {
    if (_index + 1 >= _questions.length) {
      await _showResult();
      return;
    }
    setState(() {
      _index++;
      _dropped = null;
      _correct = false;
    });
  }

  Future<void> _showResult() async {
    final childId = context.read<AppState>().currentChild?.id;
    final result = await QuizCompletionService.instance.record(
      childId: childId,
      category: 'drag_drop',
      score: _score,
      total: _questions.length,
    );
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          'Great Effort!',
          style: TextStyle(fontFamily: 'arlrdbd'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score: ${result.score} / ${result.total}',
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              '⭐ +${result.starsAwarded}   🪙 +${result.coinsAwarded}',
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Done', style: TextStyle(fontFamily: 'arlrdbd')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Drag & Drop Quiz',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageHeight =
                (constraints.maxHeight * 0.35).clamp(150.0, 260.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
                child: Column(
                  children: [
                    Text(
                      q.prompt,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
                    ),
                    const SizedBox(height: 24),
                    DragTarget<String>(
                      onWillAcceptWithDetails: (_) => _dropped == null,
                      onAcceptWithDetails: (details) =>
                          _onAccept(details.data),
                      builder: (_, __, ___) => Container(
                        height: imageHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _dropped == null
                              ? Colors.white
                              : (_correct
                                  ? const Color(0xFFE4F2E6)
                                  : const Color(0xFFFFE4E4)),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFF19335),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF19335).withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(q.imageAsset,
                                  height: imageHeight - 40),
                            ),
                            if (_dropped != null)
                              Positioned(
                                right: 16,
                                top: 16,
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: _correct
                                      ? const Color(0xFF6DB072)
                                      : Colors.red,
                                  child: Text(
                                    _dropped!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'arlrdbd',
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: q.options
                          .map(
                            (letter) => Draggable<String>(
                              data: letter,
                              feedback: _letterChip(letter, dragging: true),
                              childWhenDragging:
                                  _letterChip(letter, faded: true),
                              child: _letterChip(letter),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 40),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF19335),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                        ),
                        onPressed: _dropped != null ? _next : null,
                        child: Text(
                          _index + 1 == _questions.length
                              ? 'See Result'
                              : 'Next',
                          style: const TextStyle(
                            fontFamily: 'arlrdbd',
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _letterChip(String letter,
      {bool dragging = false, bool faded = false}) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: faded
              ? Colors.grey.shade300
              : (dragging
                  ? const Color(0xFFEBE8FD)
                  : const Color(0xFFFEF9E4)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF19335), width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: const TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 28,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

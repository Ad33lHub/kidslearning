import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ShapeMatchingScreen extends StatefulWidget {
  const ShapeMatchingScreen({super.key});

  @override
  State<ShapeMatchingScreen> createState() => _ShapeMatchingScreenState();
}

class _ShapeMatchingScreenState extends State<ShapeMatchingScreen> {
  final FlutterTts _tts = FlutterTts();
  int _score = 0;
  int _total = 0;
  int _currentIndex = 0;
  int? _selectedOption;
  late List<_ShapeItem> _shuffledOptions;

  static const _shapes = [
    _ShapeItem('Circle', '⭕'),
    _ShapeItem('Square', '🟦'),
    _ShapeItem('Triangle', '🔺'),
    _ShapeItem('Star', '⭐'),
    _ShapeItem('Heart', '❤️'),
    _ShapeItem('Diamond', '💎'),
    _ShapeItem('Oval', '🥚'),
    _ShapeItem('Pentagon', '⬠'),
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('en-US');
    _tts.setPitch(1.5);
    _newQuestion();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _newQuestion() {
    _currentIndex = _total % _shapes.length;
    final correct = _shapes[_currentIndex];
    final allOthers = List.from(_shapes)
      ..removeWhere((s) => s.name == correct.name)
      ..shuffle();
    final options = [correct, ...allOthers.take(3)]..shuffle();
    _shuffledOptions = List<_ShapeItem>.from(options);
    _selectedOption = null;
    _tts.speak('What shape is this?');
  }

  void _onSelect(int optIndex) {
    if (_selectedOption != null) return;
    setState(() {
      _selectedOption = optIndex;
      _total++;
      if (_shuffledOptions[optIndex].name == _shapes[_currentIndex].name) {
        _score++;
        _tts.speak('Correct! ${_shapes[_currentIndex].name}');
      } else {
        _tts.speak(
          'No! This is a ${_shapes[_currentIndex].name}',
        );
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _newQuestion());
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _shapes[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Shape Matching',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_score/$_total',
                style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'What shape is this?',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
            ),
          ),
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(current.emoji, style: const TextStyle(fontSize: 100)),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: List.generate(_shuffledOptions.length, (i) {
                  final opt = _shuffledOptions[i];
                  Color color = Colors.white;
                  if (_selectedOption != null) {
                    if (opt.name == current.name) {
                      color = const Color(0xFF6DB072);
                    } else if (i == _selectedOption) {
                      color = Colors.red.shade200;
                    }
                  }
                  return GestureDetector(
                    onTap: () => _onSelect(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFF19335),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(opt.emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Text(
                              opt.name,
                              style: const TextStyle(
                                fontFamily: 'arlrdbd',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapeItem {
  final String name;
  final String emoji;
  const _ShapeItem(this.name, this.emoji);
}

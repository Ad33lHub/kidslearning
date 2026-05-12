import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LetterMatchingScreen extends StatefulWidget {
  const LetterMatchingScreen({super.key});

  @override
  State<LetterMatchingScreen> createState() => _LetterMatchingScreenState();
}

class _LetterMatchingScreenState extends State<LetterMatchingScreen> {
  final FlutterTts _tts = FlutterTts();
  int _round = 0;
  int _score = 0;
  Map<String, String?> _matched = {};
  late List<String> _upperLetters;
  late List<String> _lowerShuffled;

  static const _allLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('en-US');
    _tts.setPitch(1.5);
    _setupRound();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  void _setupRound() {
    final start = (_round * 4) % _allLetters.length;
    _upperLetters = List.generate(
      4,
      (i) => _allLetters[(start + i) % _allLetters.length],
    );
    _lowerShuffled = List.from(_upperLetters)..shuffle();
    _matched = {for (final l in _upperLetters) l: null};
  }

  bool get _allMatched =>
      _matched.values.every((v) => v != null);

  void _onDrop(String upper, String lower) {
    setState(() {
      if (upper == lower) {
        _matched[upper] = lower;
        _score++;
        _tts.speak('Correct! $upper');
      } else {
        _tts.speak('Try again!');
      }
    });

    if (_allMatched) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _round++;
            _setupRound();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Letter Matching',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '⭐ $_score',
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
              'Match UPPERCASE with lowercase',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _upperColumn()),
                const SizedBox(width: 24),
                Expanded(child: _lowerColumn()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _upperColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _upperLetters.map((l) {
          final isMatched = _matched[l] != null;
          return DragTarget<String>(
            onWillAcceptWithDetails: (d) => !isMatched,
            onAcceptWithDetails: (d) => _onDrop(l, d.data),
            builder: (_, candidates, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isMatched
                    ? const Color(0xFF6DB072)
                    : candidates.isNotEmpty
                        ? const Color(0xFFF19335).withOpacity(0.3)
                        : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isMatched
                      ? const Color(0xFF6DB072)
                      : const Color(0xFFF19335),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  l,
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 36,
                    color: isMatched ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );

  Widget _lowerColumn() {
    final unmatched = _lowerShuffled
        .where((l) => !_matched.values.contains(l))
        .toList();
    final matched = _lowerShuffled
        .where((l) => _matched.values.contains(l))
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _lowerShuffled.map((l) {
        final isUsed = matched.contains(l);
        return Draggable<String>(
          data: l,
          feedback: _letterChip(l, dragging: true),
          childWhenDragging: _letterChip(l, faded: true),
          child: isUsed ? _letterChip(l, faded: true) : _letterChip(l),
        );
      }).toList(),
    );
  }

  Widget _letterChip(
    String l, {
    bool dragging = false,
    bool faded = false,
  }) =>
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: faded
              ? Colors.grey.shade200
              : dragging
                  ? const Color(0xFFF19335)
                  : const Color(0xFFEBE8FD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: dragging
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            l.toLowerCase(),
            style: TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 36,
              color: faded ? Colors.grey : Colors.black87,
            ),
          ),
        ),
      );
}

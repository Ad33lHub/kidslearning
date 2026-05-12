import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CountingActivityScreen extends StatefulWidget {
  const CountingActivityScreen({super.key});

  @override
  State<CountingActivityScreen> createState() => _CountingActivityScreenState();
}

class _CountingActivityScreenState extends State<CountingActivityScreen> {
  final FlutterTts _tts = FlutterTts();
  final _rng = Random();
  int _count = 1;
  late List<int> _options;
  int? _selected;
  int _score = 0;
  int _total = 0;

  static const _animals = ['🐶', '🐱', '🐸', '🦋', '⭐', '🍎', '🌻', '🐘'];

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
    _count = _rng.nextInt(10) + 1;
    final correct = _count;
    final opts = <int>{correct};
    while (opts.length < 4) {
      opts.add(_rng.nextInt(10) + 1);
    }
    _options = opts.toList()..shuffle();
    _selected = null;
  }

  void _onSelect(int val) {
    if (_selected != null) return;
    setState(() {
      _selected = val;
      _total++;
      if (val == _count) {
        _score++;
        _tts.speak('Correct! $_count');
      } else {
        _tts.speak('Try again! The answer is $_count');
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _newQuestion());
    });
  }

  @override
  Widget build(BuildContext context) {
    final emoji = _animals[_rng.nextInt(_animals.length) % _animals.length];

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Counting Activity',
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
              'How many do you see?',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  _count,
                  (_) => Text(
                    '🐶',
                    style: TextStyle(
                      fontSize: _count <= 5 ? 56 : _count <= 8 ? 44 : 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: _options.map((opt) {
                Color color = Colors.white;
                if (_selected != null) {
                  if (opt == _count) {
                    color = const Color(0xFF6DB072);
                  } else if (opt == _selected) {
                    color = Colors.red.shade200;
                  }
                }
                return GestureDetector(
                  onTap: () => _onSelect(opt),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFF19335),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$opt',
                        style: const TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

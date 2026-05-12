import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AnimalSoundScreen extends StatefulWidget {
  const AnimalSoundScreen({super.key});

  @override
  State<AnimalSoundScreen> createState() => _AnimalSoundScreenState();
}

class _AnimalSoundScreenState extends State<AnimalSoundScreen> {
  final FlutterTts _tts = FlutterTts();
  final _rng = Random();
  int _score = 0;
  int _total = 0;
  int? _selectedIndex;
  late int _correctIndex;
  late List<_Animal> _options;
  bool _listening = false;

  static const _animals = [
    _Animal('Bear', 'assets/images/1beer.png', 'growl'),
    _Animal('Cat', 'assets/images/1cat.png', 'meow'),
    _Animal('Dog', 'assets/images/1dog.png', 'woof'),
    _Animal('Elephant', 'assets/images/1elephent.png', 'trumpet'),
    _Animal('Horse', 'assets/images/1horse.png', 'neigh'),
    _Animal('Lion', 'assets/images/1lion.png', 'roar'),
    _Animal('Cow', 'assets/images/1bull.png', 'moo'),
    _Animal('Fox', 'assets/images/1fox.png', 'bark'),
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
    final allAnimals = List<_Animal>.from(_animals)..shuffle(_rng);
    _options = allAnimals.take(4).toList();
    _correctIndex = _rng.nextInt(4);
    _selectedIndex = null;
    _listening = false;
  }

  Future<void> _playSound() async {
    setState(() => _listening = true);
    final correct = _options[_correctIndex];
    await _tts.speak('I am a ${correct.name}. I say ${correct.sound}!');
    if (mounted) setState(() => _listening = false);
  }

  void _onSelect(int index) {
    if (_selectedIndex != null) return;
    setState(() {
      _selectedIndex = index;
      _total++;
      if (index == _correctIndex) {
        _score++;
        _tts.speak('Correct! That is a ${_options[_correctIndex].name}');
      } else {
        _tts.speak('No! That was the ${_options[_correctIndex].name}');
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _newQuestion());
    });
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
          'Animal Sounds',
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
              'Listen and pick the right animal!',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: _listening ? null : _playSound,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _listening
                    ? const Color(0xFFF19335)
                    : const Color(0xFFEBE8FD),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF19335).withOpacity(0.3),
                    blurRadius: _listening ? 20 : 8,
                    spreadRadius: _listening ? 8 : 0,
                  ),
                ],
              ),
              child: Icon(
                _listening ? Icons.volume_up : Icons.play_arrow,
                size: 56,
                color: _listening ? Colors.white : const Color(0xFFF19335),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _listening ? 'Listening...' : 'Tap to hear the sound',
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: List.generate(4, (i) {
                  final animal = _options[i];
                  Color border = Colors.grey.shade300;
                  if (_selectedIndex != null) {
                    if (i == _correctIndex) border = const Color(0xFF6DB072);
                    if (i == _selectedIndex && i != _correctIndex) {
                      border = Colors.red;
                    }
                  }
                  return GestureDetector(
                    onTap: () => _onSelect(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border, width: 3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            animal.imagePath,
                            height: 90,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.pets, size: 60),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            animal.name,
                            style: const TextStyle(
                              fontFamily: 'arlrdbd',
                              fontSize: 14,
                            ),
                          ),
                        ],
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

class _Animal {
  final String name;
  final String imagePath;
  final String sound;
  const _Animal(this.name, this.imagePath, this.sound);
}

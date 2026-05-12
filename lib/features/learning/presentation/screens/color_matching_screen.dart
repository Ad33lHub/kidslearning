import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ColorMatchingScreen extends StatefulWidget {
  const ColorMatchingScreen({super.key});

  @override
  State<ColorMatchingScreen> createState() => _ColorMatchingScreenState();
}

class _ColorMatchingScreenState extends State<ColorMatchingScreen> {
  final FlutterTts _tts = FlutterTts();
  int _score = 0;
  Map<String, String?> _matches = {};
  late List<_ColorItem> _items;
  late List<_ColorItem> _shuffledLabels;

  static const _allColors = [
    _ColorItem('Red', Color(0xFFE53935)),
    _ColorItem('Blue', Color(0xFF1E88E5)),
    _ColorItem('Green', Color(0xFF43A047)),
    _ColorItem('Yellow', Color(0xFFFDD835)),
    _ColorItem('Orange', Color(0xFFFB8C00)),
    _ColorItem('Purple', Color(0xFF8E24AA)),
    _ColorItem('Pink', Color(0xFFE91E8C)),
    _ColorItem('Brown', Color(0xFF6D4C41)),
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
    _items = List.from(_allColors)..shuffle();
    _items = _items.take(4).toList();
    _shuffledLabels = List.from(_items)..shuffle();
    _matches = {for (final c in _items) c.name: null};
  }

  bool get _allMatched => _matches.values.every((v) => v != null);

  void _onDrop(String targetName, String droppedName) {
    if (targetName == droppedName) {
      setState(() {
        _matches[targetName] = droppedName;
        _score++;
        _tts.speak('Correct! $targetName');
      });
      if (_allMatched) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() => _setupRound());
        });
      }
    } else {
      _tts.speak('Try again!');
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
          'Color Matching',
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
            padding: EdgeInsets.all(12),
            child: Text(
              'Drag the color to its name!',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _colorCirclesColumn()),
                const SizedBox(width: 16),
                Expanded(child: _labelTargetsColumn()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorCirclesColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _shuffledLabels.map((item) {
          final isUsed = _matches.values.contains(item.name);
          return Draggable<String>(
            data: item.name,
            feedback: _colorCircle(item, size: 72),
            childWhenDragging: _colorCircle(item, size: 64, faded: true),
            child: isUsed
                ? _colorCircle(item, size: 64, faded: true)
                : _colorCircle(item, size: 64),
          );
        }).toList(),
      );

  Widget _labelTargetsColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _items.map((item) {
          final isMatched = _matches[item.name] != null;
          return DragTarget<String>(
            onWillAcceptWithDetails: (_) => !isMatched,
            onAcceptWithDetails: (d) => _onDrop(item.name, d.data),
            builder: (_, candidates, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 120,
              height: 56,
              decoration: BoxDecoration(
                color: isMatched
                    ? item.color
                    : candidates.isNotEmpty
                        ? item.color.withOpacity(0.3)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isMatched ? item.color : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 16,
                    color: isMatched ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );

  Widget _colorCircle(
    _ColorItem item, {
    required double size,
    bool faded = false,
  }) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: faded ? item.color.withOpacity(0.3) : item.color,
          boxShadow: faded
              ? null
              : [
                  BoxShadow(
                    color: item.color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
      );
}

class _ColorItem {
  final String name;
  final Color color;
  const _ColorItem(this.name, this.color);
}

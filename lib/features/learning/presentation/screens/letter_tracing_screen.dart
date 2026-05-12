import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LetterTracingScreen extends StatefulWidget {
  const LetterTracingScreen({super.key});

  @override
  State<LetterTracingScreen> createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen> {
  int _index = 0;
  final List<Offset> _points = [];
  bool _traced = false;
  final FlutterTts _tts = FlutterTts();

  static const _letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('en-US');
    _tts.setPitch(1.5);
    _speak();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak() async {
    await _tts.speak(_letters[_index]);
  }

  void _next() {
    if (_index < _letters.length - 1) {
      setState(() {
        _index++;
        _points.clear();
        _traced = false;
      });
      _speak();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _points.clear();
        _traced = false;
      });
      _speak();
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _points.add(d.localPosition);
      if (_points.length > 30) _traced = true;
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_traced) {
      _tts.speak('Great job! ${_letters[_index]}');
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
          'Letter Tracing',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Trace the letter  ${_letters[_index]}',
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _letters.length,
              (i) => Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _index
                      ? const Color(0xFFF19335)
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFF19335),
                        width: 3,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _letters[_index],
                        style: TextStyle(
                          fontSize: 180,
                          color: Colors.grey.shade200,
                          fontFamily: 'arlrdbd',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      size: const Size(280, 280),
                      painter: _TracePainter(_points),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_traced)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                '⭐ Great Job! ⭐',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 22,
                  color: Color(0xFFF19335),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _index > 0 ? _prev : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6DB072),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _points.clear();
                      _traced = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: _speak,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF19335),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: _index < _letters.length - 1 ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6DB072),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TracePainter extends CustomPainter {
  final List<Offset> points;
  _TracePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF19335).withOpacity(0.7)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < points.length - 1; i++) {
      path.moveTo(points[i].dx, points[i].dy);
      path.lineTo(points[i + 1].dx, points[i + 1].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TracePainter old) => old.points != points;
}

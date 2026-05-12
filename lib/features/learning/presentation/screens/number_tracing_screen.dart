import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NumberTracingScreen extends StatefulWidget {
  const NumberTracingScreen({super.key});

  @override
  State<NumberTracingScreen> createState() => _NumberTracingScreenState();
}

class _NumberTracingScreenState extends State<NumberTracingScreen> {
  int _index = 0;
  final List<Offset> _points = [];
  bool _traced = false;
  final FlutterTts _tts = FlutterTts();

  static const _numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static const _words = [
    'Zero', 'One', 'Two', 'Three', 'Four',
    'Five', 'Six', 'Seven', 'Eight', 'Nine',
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
    await _tts.speak('${_numbers[_index]}, ${_words[_index]}');
  }

  void _next() {
    if (_index < _numbers.length - 1) {
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
      _tts.speak('Excellent! ${_words[_index]}');
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
          'Number Tracing',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Trace the number  ${_numbers[_index]}',
            style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            _words[_index],
            style: const TextStyle(
              fontFamily: 'arlrdbd',
              fontSize: 16,
              color: Color(0xFFF19335),
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
                        color: const Color(0xFF6DB072),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _numbers[_index],
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
                '⭐ Excellent! ⭐',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 22,
                  color: Color(0xFF6DB072),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(Icons.arrow_back, const Color(0xFF6DB072), _index > 0 ? _prev : null),
                _navBtn(Icons.refresh, Colors.grey, () => setState(() {
                  _points.clear();
                  _traced = false;
                })),
                _navBtn(Icons.volume_up, const Color(0xFFF19335), _speak),
                _navBtn(Icons.arrow_forward, const Color(0xFF6DB072), _index < _numbers.length - 1 ? _next : null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, Color color, VoidCallback? onTap) =>
      ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Icon(icon, color: Colors.white),
      );
}

class _TracePainter extends CustomPainter {
  final List<Offset> points;
  _TracePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6DB072).withOpacity(0.7)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
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

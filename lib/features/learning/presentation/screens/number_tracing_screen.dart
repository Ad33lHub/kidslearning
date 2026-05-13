import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class NumberTracingScreen extends StatefulWidget {
  const NumberTracingScreen({super.key});

  @override
  State<NumberTracingScreen> createState() => _NumberTracingScreenState();
}

class _NumberTracingScreenState extends State<NumberTracingScreen> {
  int _index = 0;
  final List<List<Offset>> _strokes = [[]];
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
        _strokes.clear();
        _strokes.add([]);
        _traced = false;
      });
      _speak();
    }
  }

  void _prev() {
    if (_index > 0) {
      setState(() {
        _index--;
        _strokes.clear();
        _strokes.add([]);
        _traced = false;
      });
      _speak();
    }
  }

  void _onPanStart(DragStartDetails d) {
    setState(() {
      _strokes.add([d.localPosition]);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _strokes.last.add(d.localPosition);
      final totalPoints =
          _strokes.fold<int>(0, (sum, s) => sum + s.length);
      if (totalPoints > 30) _traced = true;
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_traced) {
      _tts.speak('Excellent! ${_words[_index]}');
    }
  }

  void _clearCanvas() {
    setState(() {
      _strokes.clear();
      _strokes.add([]);
      _traced = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final canvasSize = (screenSize.width * 0.70).clamp(200.0, 320.0);

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
      body: SafeArea(
        child: Column(
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
                      width: canvasSize,
                      height: canvasSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _traced
                              ? const Color(0xFF6DB072)
                              : const Color(0xFF6DB072).withOpacity(0.4),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _numbers[_index],
                          style: TextStyle(
                            fontSize: canvasSize * 0.64,
                            color: Colors.grey.shade200,
                            fontFamily: 'arlrdbd',
                          ),
                        ),
                      ),
                    ),
                    // Drawing surface — gesture-isolated
                    SizedBox(
                      width: canvasSize,
                      height: canvasSize,
                      child: GestureDetector(
                        onPanStart: _onPanStart,
                        onPanUpdate: _onPanUpdate,
                        onPanEnd: _onPanEnd,
                        behavior: HitTestBehavior.opaque,
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: Size(canvasSize, canvasSize),
                            painter: _TracePainter(_strokes),
                          ),
                        ),
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
                  _navBtn(Icons.arrow_back, const Color(0xFF6DB072),
                      _index > 0 ? _prev : null),
                  _navBtn(Icons.refresh, Colors.grey, _clearCanvas),
                  _navBtn(Icons.volume_up, const Color(0xFFF19335), _speak),
                  _navBtn(Icons.arrow_forward, const Color(0xFF6DB072),
                      _index < _numbers.length - 1 ? _next : null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, Color color, VoidCallback? onTap) =>
      ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: onTap != null ? color : Colors.grey.shade300,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
          elevation: onTap != null ? 4 : 0,
        ),
        child: Icon(icon, color: Colors.white),
      );
}

class _TracePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  _TracePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6DB072).withOpacity(0.7)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.length < 2) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter old) => true;
}

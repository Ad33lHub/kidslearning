import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/learning_sessions_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/services/quiz_completion_service.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

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

  // Progress tracking
  int _tracedCount = 0;
  int _sessionId = -1;
  late DateTime _sessionStart;

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
    Future.microtask(_startSession);
  }

  Future<void> _startSession() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) return;
    _sessionStart = DateTime.now();
    final db = await AppDatabase.instance.database;
    _sessionId = await LearningSessionsRepository(db).startSession(
      childId: childId,
      module: 'alphabet',
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _saveProgress();
    super.dispose();
  }

  void _saveProgress() {
    if (_tracedCount == 0) return;
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) return;
    QuizCompletionService.instance.record(
      childId: childId,
      category: 'alphabet',
      score: _tracedCount,
      total: _index + 1,
      openSessionId: _sessionId >= 0 ? _sessionId : null,
      sessionStart: _sessionStart,
    );
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
      if (_points.length > 30 && !_traced) {
        _traced = true;
        _tracedCount++;
      }
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_traced) {
      _tts.speak('Great job! ${_letters[_index]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final letter = _letters[_index];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            backgroundColor: AppColors.primaryDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Letter Tracing',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientAlphabet,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '✏️ $_tracedCount traced',
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'Trace the letter  $letter',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                // Progress dots
                SizedBox(
                  height: 12,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _letters.length,
                    itemBuilder: (_, i) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _index
                            ? AppColors.success
                            : i == _index
                                ? AppColors.primary
                                : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                            border: Border.all(
                              color: _traced
                                  ? AppColors.success
                                  : AppColors.primaryLight,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontSize: 180,
                                color: Colors.grey.shade100,
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
                            painter: _TracePainter(_points, _traced),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_traced)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: 6),
                        Text(
                          'Great Job! +1 Star',
                          style: const TextStyle(
                            fontFamily: 'arlrdbd',
                            fontSize: 20,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('⭐', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBtn(
                        icon: Icons.arrow_back_rounded,
                        color: AppColors.primaryLight,
                        onPressed: _index > 0 ? _prev : null,
                      ),
                      _NavBtn(
                        icon: Icons.refresh_rounded,
                        color: Colors.grey,
                        onPressed: () => setState(() {
                          _points.clear();
                          _traced = false;
                        }),
                      ),
                      _NavBtn(
                        icon: Icons.volume_up_rounded,
                        color: AppColors.accent,
                        onPressed: _speak,
                      ),
                      _NavBtn(
                        icon: Icons.arrow_forward_rounded,
                        color: AppColors.primaryLight,
                        onPressed: _index < _letters.length - 1 ? _next : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _NavBtn({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: onPressed != null ? color : Colors.grey.shade300,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: onPressed != null ? 4 : 0,
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class _TracePainter extends CustomPainter {
  final List<Offset> points;
  final bool traced;
  _TracePainter(this.points, this.traced);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (traced ? AppColors.primary : AppColors.primaryLight)
          .withOpacity(0.75)
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
  bool shouldRepaint(covariant _TracePainter old) =>
      old.points != points || old.traced != traced;
}

import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/learning_sessions_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  List<LearningSession> _sessions = [];
  List<QuizScore> _quizScores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) return;
    final db = await AppDatabase.instance.database;
    final sessRepo = LearningSessionsRepository(db);
    final quizRepo = QuizScoresRepository(db);
    final sessions = await sessRepo.recentSessions(childId: childId);
    final quizzes = await quizRepo.history();
    if (mounted) {
      setState(() {
        _sessions = sessions;
        _quizScores = quizzes;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFEF7F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFEF7F0),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Activity History',
            style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontFamily: 'arlrdbd'),
            indicatorColor: Color(0xFFF19335),
            labelColor: Color(0xFFF19335),
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Learning Sessions'),
              Tab(text: 'Quiz Scores'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _sessionsTab(),
                  _quizTab(),
                ],
              ),
      ),
    );
  }

  Widget _sessionsTab() {
    if (_sessions.isEmpty) {
      return const Center(
        child: Text(
          'No sessions yet.',
          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sessions.length,
      itemBuilder: (_, i) {
        final s = _sessions[i];
        final mins = s.durationSeconds ~/ 60;
        final secs = s.durationSeconds % 60;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.book, color: Color(0xFFF19335)),
            title: Text(
              s.module,
              style: const TextStyle(fontFamily: 'arlrdbd'),
            ),
            subtitle: Text(
              _fmtDate(s.startedAt),
              style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
            ),
            trailing: Text(
              '${mins}m ${secs}s',
              style: const TextStyle(fontFamily: 'arlrdbd', color: Color(0xFF6DB072)),
            ),
          ),
        );
      },
    );
  }

  Widget _quizTab() {
    if (_quizScores.isEmpty) {
      return const Center(
        child: Text(
          'No quiz scores yet.',
          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _quizScores.length,
      itemBuilder: (_, i) {
        final q = _quizScores[i];
        final pct = (q.score / q.total * 100).round();
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.quiz, color: Color(0xFFF19335)),
            title: Text(
              q.category,
              style: const TextStyle(fontFamily: 'arlrdbd'),
            ),
            subtitle: Text(
              _fmtDate(q.completedAt),
              style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
            ),
            trailing: Text(
              '$pct%',
              style: TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 18,
                color: pct >= 70 ? const Color(0xFF6DB072) : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

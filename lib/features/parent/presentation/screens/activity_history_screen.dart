import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/learning_sessions_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
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
    if (childId == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final db = await AppDatabase.instance.database;
    final sessRepo = LearningSessionsRepository(db);
    final quizRepo = QuizScoresRepository(db);
    final sessions = await sessRepo.recentSessions(childId: childId);
    final quizzes = await quizRepo.historyFor(childId);
    if (mounted) {
      setState(() {
        _sessions = sessions;
        _quizScores = quizzes;
        _loading = false;
      });
    }
  }

  static String _emojiFor(String category) {
    switch (category.toLowerCase()) {
      case 'alphabet':
        return '📚';
      case 'numbers':
        return '🔢';
      case 'colors':
        return '🎨';
      case 'shapes':
        return '🔷';
      case 'animals':
        return '🦁';
      case 'birds':
        return '🦅';
      case 'flowers':
        return '🌸';
      case 'fruits':
        return '🍎';
      case 'months':
        return '📅';
      case 'vegetables':
        return '🥦';
      default:
        return '📖';
    }
  }

  static List<Color> _gradientFor(String category) {
    switch (category.toLowerCase()) {
      case 'alphabet':
        return AppColors.gradientAlphabet;
      case 'numbers':
        return AppColors.gradientNumbers;
      case 'colors':
        return AppColors.gradientColors;
      case 'shapes':
        return AppColors.gradientShapes;
      case 'animals':
        return AppColors.gradientAnimals;
      case 'birds':
        return AppColors.gradientBirds;
      case 'flowers':
        return AppColors.gradientFlowers;
      case 'fruits':
        return AppColors.gradientFruits;
      case 'months':
        return AppColors.gradientMonths;
      case 'vegetables':
        return AppColors.gradientVegetables;
      default:
        return AppColors.gradientLearning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: AppColors.primaryDark,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Activity History',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                labelStyle: const TextStyle(fontFamily: 'arlrdbd'),
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.20),
                ),
                tabs: const [
                  Tab(text: 'Sessions'),
                  Tab(text: 'Quiz Scores'),
                ],
              ),
            ),
          ],
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : TabBarView(
                  children: [
                    _sessionsTab(),
                    _quizTab(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _sessionsTab() {
    if (_sessions.isEmpty) {
      return const Center(
        child: Text(
          'No sessions yet.',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
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
        final gradient = _gradientFor(s.module);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _emojiFor(s.module),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            title: Text(
              s.module[0].toUpperCase() + s.module.substring(1),
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              _fmtDate(s.startedAt),
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${mins}m ${secs}s',
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 13,
                  color: AppColors.success,
                ),
              ),
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
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _quizScores.length,
      itemBuilder: (_, i) {
        final q = _quizScores[i];
        final pct = q.total > 0 ? (q.score / q.total * 100).round() : 0;
        final gradient = _gradientFor(q.category);
        final pctColor = pct >= 70
            ? AppColors.success
            : pct >= 40
                ? AppColors.warning
                : AppColors.error;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  _emojiFor(q.category),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            title: Text(
              q.category[0].toUpperCase() + q.category.substring(1),
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              '${q.score}/${q.total} correct  ·  ${_fmtDate(q.completedAt)}',
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: pctColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$pct%',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 16,
                  color: pctColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}  '
      '${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}

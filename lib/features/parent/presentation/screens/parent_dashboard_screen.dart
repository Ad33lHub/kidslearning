import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/db/daily_usage_repository.dart';
import 'package:kids/core/db/learning_sessions_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

import 'activity_history_screen.dart';
import 'child_list_screen.dart';
import 'screen_time_settings_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _totalLearningSecs = 0;
  int _usedTodaySecs = 0;
  int _limitSecs = 3600;
  Map<String, int> _secsPerModule = {};
  List<QuizScore> _recentQuiz = [];
  List<ChildEntity> _children = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final state = context.read<AppState>();
    final childId = state.currentChild?.id;
    final parentId = state.parentId;
    if (parentId == null) return;

    final db = await AppDatabase.instance.database;
    final sessRepo = LearningSessionsRepository(db);
    final usageRepo = DailyUsageRepository(db);
    final quizRepo = QuizScoresRepository(db);
    final childRepo = ChildrenRepository(db);

    final children = await childRepo.listByParent(parentId);

    int totalSecs = 0;
    int usedToday = 0;
    int limit = 3600;
    Map<String, int> perModule = {};
    List<QuizScore> quiz = [];

    if (childId != null) {
      totalSecs = await sessRepo.totalSecondsForChild(childId);
      usedToday = await usageRepo.getUsedSeconds(childId);
      limit = await usageRepo.getLimitSeconds(childId);
      perModule = await sessRepo.secondsPerModule(childId);
      quiz = await quizRepo.history(limit: 10);
    }

    if (mounted) {
      setState(() {
        _totalLearningSecs = totalSecs;
        _usedTodaySecs = usedToday;
        _limitSecs = limit;
        _secsPerModule = perModule;
        _recentQuiz = quiz;
        _children = children;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final child = state.currentChild;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Parent Dashboard',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black54),
            onPressed: () => state.logout(),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (child != null) _childHeader(child),
                    const SizedBox(height: 16),
                    _statsRow(),
                    const SizedBox(height: 16),
                    _screenTimeCard(),
                    const SizedBox(height: 16),
                    if (_secsPerModule.isNotEmpty) _weakAreas(),
                    if (_recentQuiz.isNotEmpty) _recentQuizCard(),
                    const SizedBox(height: 16),
                    _actionsGrid(context),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _childHeader(ChildEntity child) {
    final emoji = ChildrenRepository
        .avatarEmojis[child.avatarIndex % ChildrenRepository.avatarEmojis.length];
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 50)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              child.name,
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 22),
            ),
            Text(
              'Level: ${child.level}',
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                color: Color(0xFFF19335),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statsRow() => Row(
        children: [
          _statCard(
            '📚',
            _fmtTime(_totalLearningSecs),
            'Total Learning',
            const Color(0xFFE4F2E6),
          ),
          const SizedBox(width: 12),
          _statCard(
            '⭐',
            _recentQuiz.isNotEmpty
                ? '${(_recentQuiz.first.score / _recentQuiz.first.total * 100).round()}%'
                : '-',
            'Last Quiz',
            const Color(0xFFFEF9E4),
          ),
        ],
      );

  Widget _statCard(String icon, String value, String label, Color bg) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 20),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _screenTimeCard() {
    final usedPct = _limitSecs > 0 ? (_usedTodaySecs / _limitSecs).clamp(0.0, 1.0) : 0.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⏱ Today\'s Screen Time',
            style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: usedPct,
            backgroundColor: Colors.grey.shade200,
            color: usedPct > 0.8 ? Colors.red : const Color(0xFF6DB072),
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmtTime(_usedTodaySecs),
                style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
              ),
              Text(
                'Limit: ${_fmtTime(_limitSecs)}',
                style: const TextStyle(fontFamily: 'arlrdbd', color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weakAreas() {
    final sorted = _secsPerModule.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final weak = sorted.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚠️ Needs More Practice',
          style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...weak.map(
          (e) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.key, style: const TextStyle(fontFamily: 'arlrdbd')),
                Text(
                  _fmtTime(e.value),
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    color: Color(0xFFF19335),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _recentQuizCard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Recent Quiz Results',
            style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
          ),
          const SizedBox(height: 8),
          ..._recentQuiz.take(5).map((q) {
            final pct = (q.score / q.total * 100).round();
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(q.category, style: const TextStyle(fontFamily: 'arlrdbd')),
                  Text(
                    '$pct%',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      color: pct >= 70 ? const Color(0xFF6DB072) : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      );

  Widget _actionsGrid(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _actionTile(
            icon: '👶',
            label: 'Manage Children',
            color: const Color(0xFFE4F2E6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChildListScreen()),
            ),
          ),
          _actionTile(
            icon: '⏱',
            label: 'Screen Time',
            color: const Color(0xFFFEF9E4),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ScreenTimeSettingsScreen(),
              ),
            ).then((_) => _load()),
          ),
          _actionTile(
            icon: '📋',
            label: 'Activity History',
            color: const Color(0xFFEBE8FD),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ActivityHistoryScreen()),
            ),
          ),
          _actionTile(
            icon: '🔄',
            label: 'Switch Child',
            color: const Color(0xFFFFF9F4),
            onTap: () => context.read<AppState>().clearChild(),
          ),
        ],
      );

  Widget _actionTile({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 14),
              ),
            ],
          ),
        ),
      );

  String _fmtTime(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

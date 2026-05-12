import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/module_progress_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:provider/provider.dart';

class ChildProgressScreen extends StatefulWidget {
  const ChildProgressScreen({super.key});

  @override
  State<ChildProgressScreen> createState() => _ChildProgressScreenState();
}

class _ChildProgressScreenState extends State<ChildProgressScreen> {
  List<ModuleProgress> _progress = const [];
  Map<String, int> _bestScores = const {};
  double _overall = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final childId = context.read<AppState>().currentChild?.id;
    if (childId == null) {
      setState(() => _loading = false);
      return;
    }
    final db = await AppDatabase.instance.database;
    final progress = ModuleProgressRepository(db);
    final scores = QuizScoresRepository(db);
    final list = await progress.listFor(childId);
    final overall = await progress.overallPercentage(childId);
    final best = <String, int>{};
    for (final m in ModuleProgressRepository.allModules) {
      final b = await scores.bestScoreFor(m);
      if (b != null) best[m] = b;
    }
    if (!mounted) return;
    setState(() {
      _progress = list;
      _bestScores = best;
      _overall = overall;
      _loading = false;
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
          'Learning Progress',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _overallCard(),
                  const SizedBox(height: 16),
                  ..._moduleCards(),
                ],
              ),
            ),
    );
  }

  Widget _overallCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE4F2E6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Progress',
              style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (_overall / 100).clamp(0, 1),
                minHeight: 16,
                color: const Color(0xFF6DB072),
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_overall.toStringAsFixed(0)}% completed',
              style: const TextStyle(fontFamily: 'arlrdbd'),
            ),
          ],
        ),
      );

  List<Widget> _moduleCards() {
    final progressByModule = {for (final p in _progress) p.module: p};
    return ModuleProgressRepository.allModules.map((module) {
      final p = progressByModule[module];
      final pct = p?.percentage ?? 0;
      final best = _bestScores[module];
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _label(module),
                  style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
                ),
                Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    color: pct >= 70
                        ? const Color(0xFF6DB072)
                        : const Color(0xFFF19335),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (pct / 100).clamp(0, 1),
                minHeight: 10,
                color: const Color(0xFFF19335),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            if (best != null) ...[
              const SizedBox(height: 6),
              Text(
                'Best quiz score: $best',
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  String _label(String module) =>
      module[0].toUpperCase() + module.substring(1);
}

import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/module_progress_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
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
      if (mounted) setState(() => _loading = false);
      return;
    }
    final db = await AppDatabase.instance.database;
    final progressRepo = ModuleProgressRepository(db);
    final scoresRepo = QuizScoresRepository(db);
    final list = await progressRepo.listFor(childId);
    final overall = await progressRepo.overallPercentage(childId);
    final best = <String, int>{};
    for (final m in ModuleProgressRepository.allModules) {
      final b = await scoresRepo.bestScoreForChild(childId, m);
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

  static List<Color> _gradientFor(String module) {
    switch (module) {
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

  static String _emojiFor(String module) {
    switch (module) {
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

  @override
  Widget build(BuildContext context) {
    final child = context.watch<AppState>().currentChild;
    final title =
        child != null ? "${child.name}'s Progress" : 'Learning Progress';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              backgroundColor: AppColors.primaryDark,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
                  style: const TextStyle(
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
            ),
            if (_loading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _OverallCard(overall: _overall),
                    const SizedBox(height: 20),
                    const Text(
                      'Category Progress',
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._buildModuleCards(),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildModuleCards() {
    final byModule = {for (final p in _progress) p.module: p};
    return ModuleProgressRepository.allModules.map((module) {
      final p = byModule[module];
      return _ModuleProgressCard(
        module: module[0].toUpperCase() + module.substring(1),
        emoji: _emojiFor(module),
        gradient: _gradientFor(module),
        percentage: p?.percentage ?? 0.0,
        bestScore: _bestScores[module],
      );
    }).toList();
  }
}

class _OverallCard extends StatelessWidget {
  final double overall;
  const _OverallCard({required this.overall});

  @override
  Widget build(BuildContext context) {
    final fraction = (overall / 100).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.headerGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Center(
                  child: Text(
                    '${overall.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  overall >= 80
                      ? '🌟 Excellent work!'
                      : overall >= 50
                          ? '🚀 Keep it up!'
                          : '🌱 Just getting started!',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
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

class _ModuleProgressCard extends StatelessWidget {
  final String module;
  final String emoji;
  final List<Color> gradient;
  final double percentage;
  final int? bestScore;

  const _ModuleProgressCard({
    required this.module,
    required this.emoji,
    required this.gradient,
    required this.percentage,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      module,
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 14,
                        color: gradient.first,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _GradientBar(
                  fraction: (percentage / 100).clamp(0.0, 1.0),
                  gradient: gradient,
                ),
                if (bestScore != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    '🏆 Best score: $bestScore',
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBar extends StatelessWidget {
  final double fraction;
  final List<Color> gradient;
  const _GradientBar({required this.fraction, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 10,
        child: Stack(
          children: [
            Container(color: Colors.grey.shade200),
            FractionallySizedBox(
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/badges_repository.dart';
import 'package:kids/core/db/children_repository.dart';
import 'package:kids/core/db/daily_usage_repository.dart';
import 'package:kids/core/db/learning_sessions_repository.dart';
import 'package:kids/core/db/module_progress_repository.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/core/db/rewards_repository.dart';
import 'package:kids/core/db/streaks_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import 'activity_history_screen.dart';
import 'child_list_screen.dart';
import 'child_progress_screen.dart';
import 'screen_time_settings_screen.dart';

class _DashboardData {
  final int totalLearningSecs;
  final int usedTodaySecs;
  final int limitSecs;
  final List<ModuleProgress> moduleProgress;
  final List<QuizScore> recentQuiz;
  final RewardsSnapshot rewards;
  final StreakSnapshot streak;
  final List<BadgeEntity> badges;
  final List<ChildEntity> children;

  const _DashboardData({
    required this.totalLearningSecs,
    required this.usedTodaySecs,
    required this.limitSecs,
    required this.moduleProgress,
    required this.recentQuiz,
    required this.rewards,
    required this.streak,
    required this.badges,
    required this.children,
  });
}

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  _DashboardData? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final state = context.read<AppState>();
    final childId = state.currentChild?.id;
    final parentId = state.parentId;
    if (parentId == null) {
      setState(() => _loading = false);
      return;
    }

    final db = await AppDatabase.instance.database;

    final children = await ChildrenRepository(db).listByParent(parentId);

    int totalSecs = 0;
    int usedToday = 0;
    int limit = 3600;
    List<ModuleProgress> progress = const [];
    List<QuizScore> quiz = const [];
    RewardsSnapshot rewards = RewardsSnapshot.empty;
    StreakSnapshot streak = StreakSnapshot.empty;
    List<BadgeEntity> badges = const [];

    if (childId != null) {
      totalSecs =
          await LearningSessionsRepository(db).totalSecondsForChild(childId);
      usedToday = await DailyUsageRepository(db).getUsedSeconds(childId);
      limit = await DailyUsageRepository(db).getLimitSeconds(childId);
      progress = await ModuleProgressRepository(db).listFor(childId);
      quiz = await QuizScoresRepository(db).historyFor(childId, limit: 10);
      rewards = await RewardsRepository(db).getFor(childId);
      streak = await StreaksRepository(db).getFor(childId);
      badges = await BadgesRepository(db).listFor(childId);
    }

    if (mounted) {
      setState(() {
        _data = _DashboardData(
          totalLearningSecs: totalSecs,
          usedTodaySecs: usedToday,
          limitSecs: limit,
          moduleProgress: progress,
          recentQuiz: quiz,
          rewards: rewards,
          streak: streak,
          badges: badges,
          children: children,
        );
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final child = state.currentChild;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _buildAppBar(context, state, child),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _statsRow(),
                          const SizedBox(height: 14),
                          _screenTimeCard(),
                          const SizedBox(height: 20),
                          _sectionLabel('📊 Progress by Category'),
                          const SizedBox(height: 10),
                          _categoryProgressList(),
                          const SizedBox(height: 20),
                          _sectionLabel('🏅 Badges Earned'),
                          const SizedBox(height: 10),
                          _badgesRow(),
                          const SizedBox(height: 20),
                          if (_data!.recentQuiz.isNotEmpty) ...[
                            _sectionLabel('📝 Recent Quiz Results'),
                            const SizedBox(height: 10),
                            _recentQuizList(),
                            const SizedBox(height: 20),
                          ],
                          _sectionLabel('⚡ Quick Actions'),
                          const SizedBox(height: 10),
                          _actionsGrid(context, state),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  SliverAppBar _buildAppBar(
    BuildContext context,
    AppState state,
    dynamic child,
  ) {
    final emoji = child != null
        ? ChildrenRepository.avatarEmojis[
            child.avatarIndex % ChildrenRepository.avatarEmojis.length]
        : '👶';

    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.primaryDark,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.white70),
          onPressed: () => state.logout(),
          tooltip: 'Logout',
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.headerGradient,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child:
                                  Text(emoji, style: const TextStyle(fontSize: 30)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child?.name ?? 'No Child Selected',
                                  style: const TextStyle(
                                    fontFamily: 'arlrdbd',
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Level: ${child?.level ?? '-'}',
                                  style: const TextStyle(
                                    fontFamily: 'arlrdbd',
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_data != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _headerPill(
                                  '⭐ ${_data!.rewards.stars}',
                                  Colors.amber.shade300,
                                ),
                                const SizedBox(height: 4),
                                _headerPill(
                                  '🔥 ${_data!.streak.current}d streak',
                                  Colors.orange.shade300,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          'Parent Dashboard',
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _headerPill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'arlrdbd',
            fontSize: 12,
            color: color,
          ),
        ),
      );

  // ─── Stats Row ─────────────────────────────────────────────────────────────

  Widget _statsRow() {
    final d = _data!;
    return Row(
      children: [
        _StatCard(
          emoji: '📚',
          value: _fmtTime(d.totalLearningSecs),
          label: 'Total Learning',
          gradient: AppColors.gradientLearning,
        ),
        const SizedBox(width: 12),
        _StatCard(
          emoji: '🪙',
          value: '${d.rewards.coins}',
          label: 'Coins Earned',
          gradient: AppColors.gradientActivities,
        ),
      ],
    );
  }

  // ─── Screen Time ───────────────────────────────────────────────────────────

  Widget _screenTimeCard() {
    final d = _data!;
    final pct =
        d.limitSecs > 0 ? (d.usedTodaySecs / d.limitSecs).clamp(0.0, 1.0) : 0.0;
    final overHalf = pct > 0.5;
    final overLimit = pct >= 1.0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⏱', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              const Text(
                "Today's Screen Time",
                style: TextStyle(fontFamily: 'arlrdbd', fontSize: 16),
              ),
              const Spacer(),
              if (overLimit)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIMIT REACHED',
                    style: TextStyle(
                      fontFamily: 'arlrdbd',
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 14,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(
                overLimit
                    ? AppColors.error
                    : overHalf
                        ? AppColors.warning
                        : AppColors.success,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _fmtTime(d.usedTodaySecs),
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  color: overLimit ? AppColors.error : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              Text(
                'Limit: ${_fmtTime(d.limitSecs)}',
                style: const TextStyle(
                  fontFamily: 'arlrdbd',
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Category Progress ─────────────────────────────────────────────────────

  static const _categoryMeta = <String, Map<String, dynamic>>{
    'alphabet': {'label': 'Alphabet', 'emoji': '🔤', 'gradient': AppColors.gradientAlphabet},
    'numbers': {'label': 'Numbers', 'emoji': '🔢', 'gradient': AppColors.gradientNumbers},
    'colors': {'label': 'Colors', 'emoji': '🎨', 'gradient': AppColors.gradientColors},
    'shapes': {'label': 'Shapes', 'emoji': '🔷', 'gradient': AppColors.gradientShapes},
    'animals': {'label': 'Animals', 'emoji': '🦁', 'gradient': AppColors.gradientAnimals},
    'birds': {'label': 'Birds', 'emoji': '🦜', 'gradient': AppColors.gradientBirds},
    'flowers': {'label': 'Flowers', 'emoji': '🌸', 'gradient': AppColors.gradientFlowers},
    'fruits': {'label': 'Fruits', 'emoji': '🍎', 'gradient': AppColors.gradientFruits},
    'months': {'label': 'Months', 'emoji': '📅', 'gradient': AppColors.gradientMonths},
    'vegetables': {'label': 'Vegetables', 'emoji': '🥦', 'gradient': AppColors.gradientVegetables},
  };

  Widget _categoryProgressList() {
    final byModule = {for (final p in _data!.moduleProgress) p.module: p};
    return Column(
      children: ModuleProgressRepository.allModules.map((module) {
        final p = byModule[module];
        final pct = (p?.percentage ?? 0.0) / 100.0;
        final meta = _categoryMeta[module]!;
        final gradient = meta['gradient'] as List<Color>;
        return _CategoryProgressTile(
          emoji: meta['emoji'] as String,
          label: meta['label'] as String,
          pct: pct,
          gradient: gradient,
          bestScore: p?.bestScore,
        );
      }).toList(),
    );
  }

  // ─── Badges ────────────────────────────────────────────────────────────────

  Widget _badgesRow() {
    final earnedKeys = _data!.badges.map((b) => b.key).toSet();
    final all = BadgeCatalog.meta.keys.toList();
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final key = all[i];
          final meta = BadgeCatalog.meta[key]!;
          final earned = earnedKeys.contains(key);
          return Column(
            children: [
              Opacity(
                opacity: earned ? 1.0 : 0.25,
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: earned
                        ? const LinearGradient(
                            colors: AppColors.gradientAnimals,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: earned ? null : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                    boxShadow: earned
                        ? [
                            BoxShadow(
                              color: AppColors.gradientAnimals.last
                                  .withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      meta['emoji'] ?? '🏅',
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 54,
                child: Text(
                  meta['label'] ?? key,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 9,
                    color: earned ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Recent Quizzes ────────────────────────────────────────────────────────

  Widget _recentQuizList() {
    return Column(
      children: _data!.recentQuiz.take(5).map((q) {
        final pct = q.total > 0 ? (q.score / q.total * 100).round() : 0;
        final meta = _categoryMeta[q.category];
        final emoji = meta?['emoji'] as String? ?? '📝';
        final gradient = (meta?['gradient'] as List<Color>?) ??
            AppColors.gradientLearning;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q.category[0].toUpperCase() + q.category.substring(1),
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _fmtDate(q.completedAt),
                      style: const TextStyle(
                        fontFamily: 'arlrdbd',
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: pct >= 70
                        ? AppColors.gradientAnimals
                        : [AppColors.error, const Color(0xFFFC8181)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$pct%',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── Actions Grid ──────────────────────────────────────────────────────────

  Widget _actionsGrid(BuildContext context, AppState state) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _ActionTile(
          emoji: '👶',
          label: 'Manage Children',
          gradient: AppColors.gradientAnimals,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChildListScreen()),
          ).then((_) => _load()),
        ),
        _ActionTile(
          emoji: '📈',
          label: 'Full Progress',
          gradient: AppColors.gradientLearning,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChildProgressScreen()),
          ),
        ),
        _ActionTile(
          emoji: '📋',
          label: 'Activity History',
          gradient: AppColors.gradientMonths,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ActivityHistoryScreen()),
          ),
        ),
        _ActionTile(
          emoji: '⏱',
          label: 'Screen Time',
          gradient: AppColors.gradientQuiz,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScreenTimeSettingsScreen(),
            ),
          ).then((_) => _load()),
        ),
        _ActionTile(
          emoji: '🔄',
          label: 'Switch Child',
          gradient: AppColors.gradientColors,
          onTap: () => state.clearChild(),
        ),
      ],
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'arlrdbd',
          fontSize: 17,
          color: AppColors.textPrimary,
        ),
      );

  String _fmtTime(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  String _fmtDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}

// ─── Reusable sub-widgets ──────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final List<Color> gradient;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProgressTile extends StatelessWidget {
  final String emoji;
  final String label;
  final double pct;
  final List<Color> gradient;
  final int? bestScore;

  const _CategoryProgressTile({
    required this.emoji,
    required this.label,
    required this.pct,
    required this.gradient,
    this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    final pctInt = (pct * 100).round();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$pctInt%',
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 15,
                  color: pctInt >= 70 ? AppColors.success : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: pct.clamp(0.0, 1.0),
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradient),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (bestScore != null && bestScore! > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Best: $bestScore correct',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String emoji;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionTile({
    required this.emoji,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.32),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

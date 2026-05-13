import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/badges_repository.dart';
import 'package:kids/core/db/rewards_repository.dart';
import 'package:kids/core/db/streaks_repository.dart';
import 'package:kids/core/providers/app_state.dart';
import 'package:kids/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  RewardsSnapshot _rewards = RewardsSnapshot.empty;
  StreakSnapshot _streak = StreakSnapshot.empty;
  List<BadgeEntity> _badges = const [];
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
    final rewards = await RewardsRepository(db).getFor(childId);
    final streak = await StreaksRepository(db).getFor(childId);
    final badges = await BadgesRepository(db).listFor(childId);
    if (!mounted) return;
    setState(() {
      _rewards = rewards;
      _streak = streak;
      _badges = badges;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  SliverAppBar(
                    expandedHeight: 140,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: const Text(
                        'My Rewards',
                        style: TextStyle(
                          fontFamily: 'arlrdbd',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: AppColors.gradientRewards,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -30,
                              right: -30,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.12),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 30,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.08),
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 20,
                              right: 24,
                              child:
                                  Text('🏆', style: TextStyle(fontSize: 44)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    backgroundColor: const Color(0xFFF59E0B),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  // Content as SliverPadding + SliverList — no nested scroll
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _statRow(),
                        const SizedBox(height: 14),
                        _streakCard(),
                        const SizedBox(height: 20),
                        _sectionTitle('Badges Earned'),
                        const SizedBox(height: 10),
                        _badgesGrid(),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'arlrdbd',
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
      );

  Widget _statRow() => Row(
        children: [
          Expanded(
            child: _statCard(
              '⭐',
              '${_rewards.stars}',
              'Stars',
              AppColors.gradientRewards,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              '🪙',
              '${_rewards.coins}',
              'Coins',
              AppColors.gradientActivities,
            ),
          ),
        ],
      );

  Widget _statCard(
    String icon,
    String value,
    String label,
    List<Color> gradient,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.last.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 42)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );

  Widget _streakCard() => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.headerGradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.30),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.20),
                shape: BoxShape.circle,
              ),
              child: const Text('🔥', style: TextStyle(fontSize: 34)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_streak.current}-Day Streak!',
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Best: ${_streak.longest} days 🏅',
                    style: const TextStyle(
                      fontFamily: 'arlrdbd',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _badgesGrid() {
    final all = BadgeCatalog.meta.keys.toList();
    final earned = _badges.map((b) => b.key).toSet();
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: all.map((key) {
        final meta = BadgeCatalog.meta[key]!;
        final isEarned = earned.contains(key);
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isEarned
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.gradientAnimals,
                  )
                : null,
            color: isEarned ? null : const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isEarned
                ? [
                    BoxShadow(
                      color: AppColors.gradientAnimals.last.withOpacity(0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isEarned ? 1 : 0.30,
                child: Text(
                  meta['emoji'] ?? '🏅',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                meta['label'] ?? key,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 11,
                  color: isEarned ? Colors.white : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

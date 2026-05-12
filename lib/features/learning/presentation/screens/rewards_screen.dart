import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/badges_repository.dart';
import 'package:kids/core/db/rewards_repository.dart';
import 'package:kids/core/db/streaks_repository.dart';
import 'package:kids/core/providers/app_state.dart';
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
      backgroundColor: const Color(0xFFFEF7F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'My Rewards',
          style: TextStyle(fontFamily: 'arlrdbd', color: Colors.black),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _statRow(),
                    const SizedBox(height: 16),
                    _streakCard(),
                    const SizedBox(height: 16),
                    const Text(
                      'Badges',
                      style: TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _badgesGrid(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statRow() => Row(
        children: [
          Expanded(
            child: _statCard(
              '⭐',
              '${_rewards.stars}',
              'Stars',
              const Color(0xFFFEF9E4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _statCard(
              '🪙',
              '${_rewards.coins}',
              'Coins',
              const Color(0xFFFFF9F4),
            ),
          ),
        ],
      );

  Widget _statCard(String icon, String value, String label, Color bg) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 24),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'arlrdbd',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );

  Widget _streakCard() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEBE8FD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('🔥', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_streak.current}-Day Streak',
                  style: const TextStyle(fontFamily: 'arlrdbd', fontSize: 18),
                ),
                Text(
                  'Best: ${_streak.longest} days',
                  style: const TextStyle(
                    fontFamily: 'arlrdbd',
                    color: Colors.black54,
                  ),
                ),
              ],
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
            color: isEarned ? const Color(0xFFE4F2E6) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isEarned ? 1 : 0.3,
                child: Text(
                  meta['emoji'] ?? '🏅',
                  style: const TextStyle(fontSize: 38),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                meta['label'] ?? key,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'arlrdbd',
                  fontSize: 11,
                  color: isEarned ? Colors.black : Colors.black45,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

import '../db/app_database.dart';
import '../db/badges_repository.dart';
import '../db/module_progress_repository.dart';
import '../db/quiz_scores_repository.dart';
import '../db/rewards_repository.dart';
import '../db/streaks_repository.dart';

class QuizCompletionResult {
  final int score;
  final int total;
  final int starsAwarded;
  final int coinsAwarded;
  final RewardsSnapshot rewards;
  final StreakSnapshot streak;
  final List<String> newBadges;

  const QuizCompletionResult({
    required this.score,
    required this.total,
    required this.starsAwarded,
    required this.coinsAwarded,
    required this.rewards,
    required this.streak,
    required this.newBadges,
  });
}

class QuizCompletionService {
  QuizCompletionService._();
  static final QuizCompletionService instance = QuizCompletionService._();

  Future<QuizCompletionResult> record({
    required int? childId,
    required String category,
    required int score,
    required int total,
  }) async {
    final db = await AppDatabase.instance.database;
    await QuizScoresRepository(db).record(
      category: category,
      score: score,
      total: total,
    );

    if (childId == null) {
      return QuizCompletionResult(
        score: score,
        total: total,
        starsAwarded: 0,
        coinsAwarded: 0,
        rewards: RewardsSnapshot.empty,
        streak: StreakSnapshot.empty,
        newBadges: const [],
      );
    }

    final stars = _starsFor(score: score, total: total);
    final coins = score * 5;

    final rewards = await RewardsRepository(db)
        .award(childId: childId, stars: stars, coins: coins);

    await ModuleProgressRepository(db).recordQuizResult(
      childId: childId,
      module: category,
      score: score,
      total: total,
    );

    final streak = await StreaksRepository(db).recordActivityToday(childId);

    final badges = await _evaluateBadges(
      db: db,
      childId: childId,
      score: score,
      total: total,
      streakCurrent: streak.current,
    );

    return QuizCompletionResult(
      score: score,
      total: total,
      starsAwarded: stars,
      coinsAwarded: coins,
      rewards: rewards,
      streak: streak,
      newBadges: badges,
    );
  }

  int _starsFor({required int score, required int total}) {
    if (total <= 0) return 0;
    final pct = score / total;
    if (pct >= 0.9) return 3;
    if (pct >= 0.6) return 2;
    if (pct >= 0.3) return 1;
    return 0;
  }

  Future<List<String>> _evaluateBadges({
    required db,
    required int childId,
    required int score,
    required int total,
    required int streakCurrent,
  }) async {
    final repo = BadgesRepository(db);
    final progress = ModuleProgressRepository(db);
    final scores = QuizScoresRepository(db);
    final newlyAwarded = <String>[];

    Future<void> tryAward(String key) async {
      final wasNew = await repo.award(childId: childId, key: key);
      if (wasNew) newlyAwarded.add(key);
    }

    final allHistory = await scores.history(limit: 1000);
    if (allHistory.isNotEmpty) {
      await tryAward(BadgeCatalog.firstQuiz);
    }
    if (score == total && total > 0) {
      await tryAward(BadgeCatalog.perfectScore);
    }
    if (allHistory.length >= 5) {
      await tryAward(BadgeCatalog.fiveQuizzes);
    }
    if (streakCurrent >= 3) {
      await tryAward(BadgeCatalog.streak3);
    }
    if (streakCurrent >= 7) {
      await tryAward(BadgeCatalog.streak7);
    }
    final attempted = await progress.attemptedCategoriesCount(childId);
    if (attempted >= ModuleProgressRepository.allModules.length) {
      await tryAward(BadgeCatalog.allCategoriesTried);
    }
    return newlyAwarded;
  }
}

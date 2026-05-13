import '../db/app_database.dart';
import '../db/badges_repository.dart';
import '../db/learning_sessions_repository.dart';
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
    /// Optional: if the caller already opened a learning session, pass its id
    /// so it gets closed here; otherwise a new one-off session is recorded.
    int? openSessionId,
    DateTime? sessionStart,
  }) async {
    final db = await AppDatabase.instance.database;

    // Always persist the quiz score, now with child_id
    await QuizScoresRepository(db).record(
      category: category,
      score: score,
      total: total,
      childId: childId,
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

    // Close or record the learning session
    final sessRepo = LearningSessionsRepository(db);
    if (openSessionId != null && sessionStart != null) {
      final secs =
          DateTime.now().difference(sessionStart).inSeconds.clamp(1, 7200);
      await sessRepo.endSession(
        sessionId: openSessionId,
        durationSeconds: secs,
      );
    } else {
      // Record a single-entry session of ~1 min so the module shows in history
      final sid = await sessRepo.startSession(
        childId: childId,
        module: category,
      );
      await sessRepo.endSession(sessionId: sid, durationSeconds: 60);
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

    // Use per-child count so badges are per-child, not global
    final childCount = await scores.countForChild(childId);
    if (childCount >= 1) await tryAward(BadgeCatalog.firstQuiz);
    if (score == total && total > 0) await tryAward(BadgeCatalog.perfectScore);
    if (childCount >= 5) await tryAward(BadgeCatalog.fiveQuizzes);
    if (streakCurrent >= 3) await tryAward(BadgeCatalog.streak3);
    if (streakCurrent >= 7) await tryAward(BadgeCatalog.streak7);

    final attempted = await progress.attemptedCategoriesCount(childId);
    if (attempted >= ModuleProgressRepository.allModules.length) {
      await tryAward(BadgeCatalog.allCategoriesTried);
    }
    return newlyAwarded;
  }
}

import '../entities/game_question.dart';
import '../entities/leaderboard_entry.dart';
import '../../../../common/result.dart';

abstract class GameRepository {
  Future<Result<List<GameQuestion>>> getQuestions();

  /// Records this attempt, and updates the user's leaderboard entry only
  /// if this score beats their previous best.
  Future<Result<void>> submitAttempt({
    required String userId,
    required String displayName,
    required int score,
  });

  Future<Result<List<LeaderboardEntry>>> getLeaderboard({int limit = 20});
}
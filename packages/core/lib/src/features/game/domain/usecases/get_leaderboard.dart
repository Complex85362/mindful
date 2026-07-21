import '../repositories/game_repository.dart';
import '../entities/leaderboard_entry.dart';
import '../../../../common/result.dart';

class GetLeaderboard {
  final GameRepository repository;
  const GetLeaderboard(this.repository);

  Future<Result<List<LeaderboardEntry>>> call({int limit = 20}) {
    return repository.getLeaderboard(limit: limit);
  }
}
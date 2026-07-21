import '../repositories/game_repository.dart';
import '../../../../common/result.dart';

class SubmitAttempt {
  final GameRepository repository;
  const SubmitAttempt(this.repository);

  Future<Result<void>> call({
    required String userId,
    required String displayName,
    required int score,
  }) {
    return repository.submitAttempt(userId: userId, displayName: displayName, score: score);
  }
}
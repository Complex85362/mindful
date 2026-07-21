import '../repositories/streak_repository.dart';
import '../entities/streak.dart';
import '../../../../common/result.dart';

class RecordActivity {
  final StreakRepository repository;
  const RecordActivity(this.repository);

  Future<Result<Streak>> call(String userId) {
    return repository.recordActivity(userId);
  }
}
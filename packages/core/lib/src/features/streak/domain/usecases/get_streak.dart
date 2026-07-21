import '../repositories/streak_repository.dart';
import '../entities/streak.dart';
import '../../../../common/result.dart';

class GetStreak {
  final StreakRepository repository;
  const GetStreak(this.repository);

  Future<Result<Streak>> call(String userId) {
    return repository.getStreak(userId);
  }
}
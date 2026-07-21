import '../entities/streak.dart';
import '../../../../common/result.dart';

abstract class StreakRepository {
  Future<Result<Streak>> getStreak(String userId);
  Future<Result<Streak>> recordActivity(String userId);
}
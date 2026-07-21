import '../entities/mood_log.dart';
import '../../../../common/result.dart';

abstract class MoodRepository {
  Future<Result<MoodLog>> logMood({required String userId, required String mood});

  /// Most recent mood entry for this user, or null if they've never logged
  /// one. Deliberately NOT "today's mood" at the query level -- see the
  /// datasource for why.
  Future<Result<MoodLog?>> getLatestMood(String userId);
}
import '../repositories/mood_repository.dart';
import '../entities/mood_log.dart';
import '../../../../common/result.dart';

class LogMood {
  final MoodRepository repository;
  const LogMood(this.repository);

  Future<Result<MoodLog>> call({required String userId, required String mood}) {
    return repository.logMood(userId: userId, mood: mood);
  }
}
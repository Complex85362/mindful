import '../repositories/mood_repository.dart';
import '../entities/mood_log.dart';
import '../../../../common/result.dart';

class GetLatestMood {
  final MoodRepository repository;
  const GetLatestMood(this.repository);

  Future<Result<MoodLog?>> call({required String userId}) {
    return repository.getLatestMood(userId);
  }
}
import '../repositories/preferences_repository.dart';
import '../../../../common/result.dart';

class GetUserPreferences {
  final PreferencesRepository repository;
  const GetUserPreferences(this.repository);

  Future<Result<List<String>>> call(String userId) {
    return repository.getUserPreferenceIds(userId);
  }
}
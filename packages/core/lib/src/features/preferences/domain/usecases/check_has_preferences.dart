import '../repositories/preferences_repository.dart';
import '../../../../common/result.dart';

class CheckHasPreferences {
  final PreferencesRepository repository;
  const CheckHasPreferences(this.repository);

  Future<Result<bool>> call({required String userId}){
    return repository.hasPreferences(userId);
  }
}
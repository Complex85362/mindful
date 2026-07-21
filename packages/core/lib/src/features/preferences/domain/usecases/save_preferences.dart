import '../repositories/preferences_repository.dart';
import '../../../../common/result.dart';

class SavePreferences {

  final PreferencesRepository repository;
  const SavePreferences(this.repository);

  Future<Result<void>> call({
    required String userId,
    required List<String> categoryIds,
}){
    return repository.savePreferences(userId: userId, categoryIds: categoryIds);
  }
}

import '../../../../common/result.dart';
import '../entities/wellness_category.dart';

abstract class PreferencesRepository {
  Future<Result<List<WellnessCategory>>> getCategories();

  Future<Result<void>> savePreferences({
    required String userId,
    required List<String> categoryIds,
});

  Future<Result<bool>> hasPreferences(String userId);
  Future<Result<List<String>>> getUserPreferenceIds(String userId);
}
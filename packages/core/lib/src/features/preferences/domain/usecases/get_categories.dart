import '../repositories/preferences_repository.dart';
import '../entities/wellness_category.dart';
import '../../../../common/result.dart';

class GetCategories {
  final PreferencesRepository repository;
  const GetCategories(this.repository);

  Future<Result<List<WellnessCategory>>> call(){
    return repository.getCategories();
  }
}
import '../repositories/favorites_repository.dart';
import '../entities/favorite.dart';
import '../../../../common/result.dart';

class GetFavorites {
  final FavoritesRepository repository;
  const GetFavorites(this.repository);

  Future<Result<List<Favorite>>> call(String userId) {
    return repository.getFavorites(userId);
  }
}
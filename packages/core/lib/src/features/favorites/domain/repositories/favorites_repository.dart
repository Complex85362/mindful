import '../entities/favorite.dart';
import '../../../../common/result.dart';

abstract class FavoritesRepository {
  Future<Result<void>> addFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  });

  Future<Result<void>> removeFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  });

  Future<Result<List<Favorite>>> getFavorites(String userId);
}
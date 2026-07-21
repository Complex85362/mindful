import '../repositories/favorites_repository.dart';
import '../../../../common/result.dart';

class RemoveFavorite {
  final FavoritesRepository repository;
  const RemoveFavorite(this.repository);

  Future<Result<void>> call({
    required String userId,
    required String itemType,
    required String itemId,
  }) {
    return repository.removeFavorite(userId: userId, itemType: itemType, itemId: itemId);
  }
}
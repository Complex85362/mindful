import '../repositories/favorites_repository.dart';
import '../../../../common/result.dart';

class AddFavorite {
  final FavoritesRepository repository;
  const AddFavorite(this.repository);

  Future<Result<void>> call({
    required String userId,
    required String itemType,
    required String itemId,
  }) {
    return repository.addFavorite(userId: userId, itemType: itemType, itemId: itemId);
  }
}
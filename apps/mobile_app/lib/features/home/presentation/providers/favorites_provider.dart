import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final AddFavorite _addFavorite;
  final RemoveFavorite _removeFavorite;
  final GetFavorites _getFavorites;

  FavoritesProvider({
    required AddFavorite addFavorite,
    required RemoveFavorite removeFavorite,
    required GetFavorites getFavorites,
  })  : _addFavorite = addFavorite,
        _removeFavorite = removeFavorite,
        _getFavorites = getFavorites;

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// O(n) scan rather than a Set/Map lookup -- deliberate for now. Your
  /// favorites list will realistically stay small (dozens, not thousands)
  /// for a student project, so this is fine. If it ever needs to scale,
  /// the fix is a Set<String> of '{itemType}_{itemId}' keys kept in sync
  /// alongside _favorites, not a rewrite of how this is called.
  bool isFavorited(String itemType, String itemId) {
    return _favorites.any((f) => f.itemType == itemType && f.itemId == itemId);
  }

  Future<void> loadFavorites(String userId) async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    _isLoading = true;
    notifyListeners();

    final result = await _getFavorites(userId);
    result.fold(
          (failure) => _errorMessage = failure.message,
          (favorites) => _favorites = List<Favorite>.of(favorites),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    final currentlyFavorited = isFavorited(itemType, itemId);

    // Optimistic update: flip local state immediately, before the network
    // call resolves, so the heart icon responds instantly on tap instead
    // of waiting on a round trip. If the call fails, we roll it back.
    if (currentlyFavorited) {
      _favorites.removeWhere((f) => f.itemType == itemType && f.itemId == itemId);
    } else {
      _favorites.add(Favorite(id: '', userId: userId, itemType: itemType, itemId: itemId));
    }
    notifyListeners();

    final result = currentlyFavorited
        ? await _removeFavorite(userId: userId, itemType: itemType, itemId: itemId)
        : await _addFavorite(userId: userId, itemType: itemType, itemId: itemId);

    result.fold(
          (failure) {
        // Roll back the optimistic change since the write actually failed.
        if (currentlyFavorited) {
          _favorites.add(Favorite(id: '', userId: userId, itemType: itemType, itemId: itemId));
        } else {
          _favorites.removeWhere((f) => f.itemType == itemType && f.itemId == itemId);
        }
        _errorMessage = failure.message;
        notifyListeners();
      },
          (_) {}, // success -- optimistic state was already correct, nothing to do
    );
  }
}
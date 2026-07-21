import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/favorite_model.dart';

class FavoritesRemoteDataSource {
  final FirebaseFirestore _firestore;

  FavoritesRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Same deterministic-ID trick as user_preferences: '{userId}_{itemType}_{itemId}'.
  // Means "favorite this again" overwrites instead of duplicating, and
  // "unfavorite" is a direct doc delete by ID -- no query needed first.
  String _docId(String userId, String itemType, String itemId) =>
      '${userId}_${itemType}_$itemId';

  Future<void> addFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    await _firestore.collection('favorites').doc(_docId(userId, itemType, itemId)).set({
      'userId': userId,
      'itemType': itemType,
      'itemId': itemId,
    });
  }

  Future<void> removeFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    await _firestore.collection('favorites').doc(_docId(userId, itemType, itemId)).delete();
  }

  Future<List<FavoriteModel>> getFavorites(String userId) async {
    final snapshot =
    await _firestore.collection('favorites').where('userId', isEqualTo: userId).get();
    return snapshot.docs.map(FavoriteModel.fromFirestore).toList();
  }
}
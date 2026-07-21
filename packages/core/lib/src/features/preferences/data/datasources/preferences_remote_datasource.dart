import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/wellness_category_model.dart';

/// The only class in this feature that talks to Firestore directly.
class PreferencesRemoteDataSource {
  final FirebaseFirestore _firestore;

  PreferencesRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<WellnessCategoryModel>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs.map(WellnessCategoryModel.fromFireStore).toList();
  }

  Future<void> savePreferences({
    required String userId,
    required List<String> categoryIds,
  }) async {
    final batch = _firestore.batch();
    for (final categoryId in categoryIds) {
      final docRef = _firestore.collection('user_preferences').doc('${userId}_$categoryId');
      batch.set(docRef, {'userId': userId, 'categoryId': categoryId});
    }
    await batch.commit();
  }

  Future<bool> hasPreferences(String userId) async {
    final snapshot = await _firestore
        .collection('user_preferences')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    return snapshot.docs.isNotEmpty;
  }
}
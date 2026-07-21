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
    // Replace, not append: clear this user's existing links first so that
    // deselecting a category during an edit (from Profile) actually takes
    // effect, instead of only ever accumulating new selections.
    final existing = await _firestore
        .collection('user_preferences')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }
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

  Future<List<String>> getUserPreferenceIds(String userId) async {
    final snapshot = await _firestore
        .collection('user_preferences')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((d) => d.data()['categoryId'] as String).toList();
  }
}
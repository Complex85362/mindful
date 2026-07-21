import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/streak_model.dart';

class StreakRemoteDataSource {
  final FirebaseFirestore _firestore;

  StreakRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Doc ID IS the userId directly (not a compound key like favorites) --
  // matches the ERD, where STREAK.userId is the primary key, meaning this
  // is genuinely a 1:1 relationship with USER, not a 1:many join table.
  DocumentReference<Map<String, dynamic>> _docRef(String userId) =>
      _firestore.collection('streaks').doc(userId);

  Future<StreakModel> getStreak(String userId) async {
    final doc = await _docRef(userId).get();
    if (!doc.exists) return StreakModel.empty(userId);
    return StreakModel.fromFirestore(doc);
  }

  Future<StreakModel> recordActivity(String userId) async {
    return _firestore.runTransaction<StreakModel>((transaction) async {
      final doc = await transaction.get(_docRef(userId));
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (!doc.exists) {
        final newStreak = StreakModel(userId: userId, currentStreak: 1, lastActiveDate: today);
        transaction.set(_docRef(userId), {
          'currentStreak': 1,
          'lastActiveDate': Timestamp.fromDate(today),
        });
        return newStreak;
      }

      final current = StreakModel.fromFirestore(doc);
      final lastActive = current.lastActiveDate;

      if (lastActive != null &&
          lastActive.year == today.year &&
          lastActive.month == today.month &&
          lastActive.day == today.day) {
        // Already recorded today -- no-op, return unchanged.
        return current;
      }

      final yesterday = today.subtract(const Duration(days: 1));
      final isConsecutive = lastActive != null &&
          lastActive.year == yesterday.year &&
          lastActive.month == yesterday.month &&
          lastActive.day == yesterday.day;

      final newCount = isConsecutive ? current.currentStreak + 1 : 1;
      final updated = StreakModel(userId: userId, currentStreak: newCount, lastActiveDate: today);
      transaction.update(_docRef(userId), {
        'currentStreak': newCount,
        'lastActiveDate': Timestamp.fromDate(today),
      });
      return updated;
    });
  }
}
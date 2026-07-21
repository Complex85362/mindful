import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/streak.dart';

class StreakModel extends Streak {
  const StreakModel({
    required super.userId,
    required super.currentStreak,
    super.lastActiveDate,
  });

  factory StreakModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final lastActiveTimestamp = data?['lastActiveDate'] as Timestamp?;
    return StreakModel(
      userId: doc.id,
      currentStreak: data?['currentStreak'] as int? ?? 0,
      lastActiveDate: lastActiveTimestamp?.toDate(),
    );
  }

  /// Represents "no streak yet" for a brand new user with no document at all.
  factory StreakModel.empty(String userId) =>
      StreakModel(userId: userId, currentStreak: 0, lastActiveDate: null);
}
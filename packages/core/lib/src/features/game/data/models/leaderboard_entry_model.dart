import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/leaderboard_entry.dart';

class LeaderboardEntryModel extends LeaderboardEntry {
  const LeaderboardEntryModel({
    required super.userId,
    required super.displayName,
    required super.score,
  });

  factory LeaderboardEntryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return LeaderboardEntryModel(
      userId: doc.id,
      displayName: data['displayName'] as String? ?? 'Anonymous',
      score: data['score'] as int? ?? 0,
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/game_question_model.dart';
import '../models/leaderboard_entry_model.dart';

class GameRemoteDataSource {
  final FirebaseFirestore _firestore;

  GameRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<GameQuestionModel>> getQuestions() async {
    final snapshot = await _firestore.collection('game_content').get();
    return snapshot.docs.map(GameQuestionModel.fromFirestore).toList();
  }

  Future<void> logAttempt({required String userId, required int score}) async {
    await _firestore.collection('game_attempts').add({
      'userId': userId,
      'score': score,
      'playedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> updateLeaderboardIfBest({
    required String userId,
    required String displayName,
    required int score,
  }) async {
    final docRef = _firestore.collection('leaderboard').doc(userId);
    // Transaction, same reasoning as the streak feature: read the existing
    // best score, only write if this attempt beats it, all atomically so
    // two rapid submissions can't race past each other incorrectly.
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      final existingBest = doc.exists ? (doc.data()?['score'] as int? ?? 0) : 0;
      if (score > existingBest) {
        transaction.set(docRef, {'displayName': displayName, 'score': score});
      }
    });
  }

  Future<List<LeaderboardEntryModel>> getLeaderboard(int limit) async {
    final snapshot = await _firestore
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map(LeaderboardEntryModel.fromFirestore).toList();
  }
}
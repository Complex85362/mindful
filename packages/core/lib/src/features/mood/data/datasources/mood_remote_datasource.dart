import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mood_log_model.dart';

class MoodRemoteDataSource {
  final FirebaseFirestore _firestore;

  MoodRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<MoodLogModel> logMood({required String userId, required String mood}) async {
    final docRef = _firestore.collection('mood_logs').doc();
    final loggedAt = DateTime.now();
    await docRef.set({
      'userId': userId,
      'mood': mood,
      'loggedAt': Timestamp.fromDate(loggedAt),
    });
    return MoodLogModel(id: docRef.id, userId: userId, mood: mood, loggedAt: loggedAt);
  }

  Future<MoodLogModel?> getLatestMood(String userId) async {
    // Deliberately querying "most recent entry" rather than filtering by
    // today's date range at the Firestore level. A range query on loggedAt
    // combined with an equality filter on userId would need the SAME
    // composite index as this does anyway, but this version is simpler:
    // we just check client-side (in the provider) whether the most recent
    // entry happens to be from today.
    final snapshot = await _firestore
        .collection('mood_logs')
        .where('userId', isEqualTo: userId)
        .orderBy('loggedAt', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    return MoodLogModel.fromFirestore(snapshot.docs.first);
  }
}
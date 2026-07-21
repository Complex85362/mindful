import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/mood_log.dart';

class MoodLogModel extends MoodLog {
  const MoodLogModel({
    required super.id,
    required super.userId,
    required super.mood,
    required super.loggedAt,
  });

  factory MoodLogModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return MoodLogModel(
      id: doc.id,
      userId: data['userId'] as String,
      mood: data['mood'] as String,
      loggedAt: (data['loggedAt'] as Timestamp).toDate(),
    );
  }
}
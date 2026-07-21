import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/game_question.dart';

class GameQuestionModel extends GameQuestion {
  const GameQuestionModel({
    required super.id,
    required super.categoryId,
    required super.authorId,
    required super.mode,
    required super.question,
    required super.options,
    required super.correctAnswerIndex,
  });

  factory GameQuestionModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GameQuestionModel(
      id: doc.id,
      categoryId: data['categoryId'] as String? ?? '',
      authorId: data['authorId'] as String? ?? '',
      mode: data['mode'] as String? ?? 'quiz',
      question: data['question'] as String? ?? '',
      options: List<String>.from(data['options'] as List? ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] as int? ?? 0,
    );
  }
}
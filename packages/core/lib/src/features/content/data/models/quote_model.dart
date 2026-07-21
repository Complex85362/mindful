import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/quote.dart';

class QuoteModel extends Quote {
  const QuoteModel({
    required super.id,
    required super.authorId,
    required super.categoryId,
    required super.text,
    super.moodTag,
  });

  factory QuoteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return QuoteModel(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      moodTag: data['moodTag'] as String?,
    );
  }
}
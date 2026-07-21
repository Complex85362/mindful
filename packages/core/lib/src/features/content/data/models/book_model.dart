import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.authorId,
    required super.title,
    super.pdfUrl,
  });

  factory BookModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BookModel(
      id: doc.id,
      authorId: data['authorId'] as String? ?? '',
      title: data['title'] as String? ?? '',

      pdfUrl: data['supabasePdfId'] as String?,
    );
  }
}
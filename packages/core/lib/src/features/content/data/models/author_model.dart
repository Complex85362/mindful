import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.id,
    required super.categoryId,
    required super.name,
    super.imageUrl,
    required super.bio,
  });

  factory AuthorModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AuthorModel(
      id: doc.id,
      categoryId: data['categoryId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      bio: data['bio'] as String? ?? '',
    );
  }
}
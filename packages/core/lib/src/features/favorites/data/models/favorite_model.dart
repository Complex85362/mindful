import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/favorite.dart';

class FavoriteModel extends Favorite {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.itemType,
    required super.itemId,
  });

  factory FavoriteModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return FavoriteModel(
      id: doc.id,
      userId: data['userId'] as String,
      itemType: data['itemType'] as String,
      itemId: data['itemId'] as String,
    );
  }
}
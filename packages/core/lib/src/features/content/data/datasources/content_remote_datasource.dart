import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/author_model.dart';
import '../models/quote_model.dart';

class ContentRemoteDataSource {
  final FirebaseFirestore _firestore;
  final Random _random;

  ContentRemoteDataSource({FirebaseFirestore? firestore, Random? random})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _random = random ?? Random();

  Future<List<AuthorModel>> getAuthors() async {
    final snapshot = await _firestore.collection('authors').get();
    return snapshot.docs.map(AuthorModel.fromFirestore).toList();
  }

  Future<QuoteModel?> getQuoteOfTheDay() async {
    
    final snapshot = await _firestore.collection('quotes').get();
    if (snapshot.docs.isEmpty) return null;
    final randomDoc = snapshot.docs[_random.nextInt(snapshot.docs.length)];
    return QuoteModel.fromFirestore(randomDoc);
  }
  Future<QuoteModel?> getQuoteById(String id) async {
    final doc = await _firestore.collection('quotes').doc(id).get();
    if (!doc.exists) return null;
    return QuoteModel.fromFirestore(doc);
  }
}
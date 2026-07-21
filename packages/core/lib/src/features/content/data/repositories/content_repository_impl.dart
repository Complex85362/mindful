import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/author.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/content_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/content_remote_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource _dataSource;

  const ContentRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Author>>> getAuthors() async {
    try {
      final authors = await _dataSource.getAuthors();
      return Result.success(authors);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load authors.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Quote?>> getQuoteOfTheDay() async {
    try {
      final quote = await _dataSource.getQuoteOfTheDay();
      return Result.success(quote);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load quote.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
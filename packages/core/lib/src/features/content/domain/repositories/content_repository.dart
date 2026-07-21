import '../entities/author.dart';
import '../entities/quote.dart';
import '../../../../common/result.dart';

abstract class ContentRepository {
  Future<Result<List<Author>>> getAuthors();
  Future<Result<Quote?>> getQuoteOfTheDay();
}
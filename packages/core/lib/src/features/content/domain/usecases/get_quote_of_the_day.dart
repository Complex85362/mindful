import '../repositories/content_repository.dart';
import '../entities/quote.dart';
import '../../../../common/result.dart';

class GetQuoteOfTheDay {
  final ContentRepository repository;
  const GetQuoteOfTheDay(this.repository);

  Future<Result<Quote?>> call() {
    return repository.getQuoteOfTheDay();
  }
}
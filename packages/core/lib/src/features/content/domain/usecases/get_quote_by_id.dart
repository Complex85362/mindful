import '../repositories/content_repository.dart';
import '../entities/quote.dart';
import '../../../../common/result.dart';

class GetQuoteById {
  final ContentRepository repository;
  const GetQuoteById(this.repository);

  Future<Result<Quote?>> call(String id) {
    return repository.getQuoteById(id);
  }
}
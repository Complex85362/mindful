import '../repositories/content_repository.dart';
import '../entities/book.dart';
import '../../../../common/result.dart';

class GetBooks {
  final ContentRepository repository;
  const GetBooks(this.repository);

  Future<Result<List<Book>>> call() {
    return repository.getBooks();
  }
}
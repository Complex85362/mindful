import '../repositories/content_repository.dart';
import '../entities/author.dart';
import '../../../../common/result.dart';

class GetAuthors {
  final ContentRepository repository;
  const GetAuthors(this.repository);

  Future<Result<List<Author>>> call() {
    return repository.getAuthors();
  }
}
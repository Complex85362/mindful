import '../repositories/game_repository.dart';
import '../entities/game_question.dart';
import '../../../../common/result.dart';

class GetQuestions {
  final GameRepository repository;
  const GetQuestions(this.repository);

  Future<Result<List<GameQuestion>>> call() {
    return repository.getQuestions();
  }
}
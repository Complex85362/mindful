import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/game_question.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/game_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/game_remote_datasource.dart';

class GameRepositoryImpl implements GameRepository {
  final GameRemoteDataSource _dataSource;

  const GameRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<GameQuestion>>> getQuestions() async {
    try {
      final questions = await _dataSource.getQuestions();
      return Result.success(questions);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load questions.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> submitAttempt({
    required String userId,
    required String displayName,
    required int score,
  }) async {
    try {
      await _dataSource.logAttempt(userId: userId, score: score);
      await _dataSource.updateLeaderboardIfBest(
        userId: userId,
        displayName: displayName,
        score: score,
      );
      return const Result.success(null);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not submit score.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<LeaderboardEntry>>> getLeaderboard({int limit = 20}) async {
    try {
      final entries = await _dataSource.getLeaderboard(limit);
      return Result.success(entries);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load leaderboard.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
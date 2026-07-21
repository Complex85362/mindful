import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/streak.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/streak_remote_datasource.dart';

class StreakRepositoryImpl implements StreakRepository {
  final StreakRemoteDataSource _dataSource;

  const StreakRepositoryImpl(this._dataSource);

  @override
  Future<Result<Streak>> getStreak(String userId) async {
    try {
      final streak = await _dataSource.getStreak(userId);
      return Result.success(streak);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load streak.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Streak>> recordActivity(String userId) async {
    try {
      final streak = await _dataSource.recordActivity(userId);
      return Result.success(streak);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not update streak.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
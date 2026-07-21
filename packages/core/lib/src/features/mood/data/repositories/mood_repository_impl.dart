import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/mood_log.dart';
import '../../domain/repositories/mood_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/mood_remote_datasource.dart';

class MoodRepositoryImpl implements MoodRepository {
  final MoodRemoteDataSource _dataSource;

  const MoodRepositoryImpl(this._dataSource);

  @override
  Future<Result<MoodLog>> logMood({required String userId, required String mood}) async {
    try {
      final log = await _dataSource.logMood(userId: userId, mood: mood);
      return Result.success(log);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not save your mood.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<MoodLog?>> getLatestMood(String userId) async {
    try {
      final log = await _dataSource.getLatestMood(userId);
      return Result.success(log);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load mood history.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
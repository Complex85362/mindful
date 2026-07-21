import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/wellness_category.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/preferences_remote_datasource.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final PreferencesRemoteDataSource _dataSource;

  const PreferencesRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<WellnessCategory>>> getCategories() async {
    try {
      final categories = await _dataSource.getCategories();
      return Result.success(categories);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load categories.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> savePreferences({
    required String userId,
    required List<String> categoryIds,
  }) async {
    try {
      await _dataSource.savePreferences(userId: userId, categoryIds: categoryIds);
      return const Result.success(null);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not save preferences.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<bool>> hasPreferences(String userId) async {
    try {
      final has = await _dataSource.hasPreferences(userId);
      return Result.success(has);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not check preferences.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
  @override
  Future<Result<List<String>>> getUserPreferenceIds(String userId) async {
    try {
      final ids = await _dataSource.getUserPreferenceIds(userId);
      return Result.success(ids);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load preferences.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
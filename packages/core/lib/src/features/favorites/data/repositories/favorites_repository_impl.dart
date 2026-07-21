import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/favorite.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource _dataSource;

  const FavoritesRepositoryImpl(this._dataSource);

  @override
  Future<Result<void>> addFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    try {
      await _dataSource.addFavorite(userId: userId, itemType: itemType, itemId: itemId);
      return const Result.success(null);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not save favorite.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> removeFavorite({
    required String userId,
    required String itemType,
    required String itemId,
  }) async {
    try {
      await _dataSource.removeFavorite(userId: userId, itemType: itemType, itemId: itemId);
      return const Result.success(null);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not remove favorite.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Favorite>>> getFavorites(String userId) async {
    try {
      final favorites = await _dataSource.getFavorites(userId);
      return Result.success(favorites);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load favorites.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../../../common/failure.dart';
import '../../../../common/result.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _dataSource;

  const ChatRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<ChatMessage>>> getHistory(String userId) async {
    try {
      final history = await _dataSource.getHistory(userId);
      return Result.success(history);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not load chat history.'));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage({
    required String userId,
    required String text,
  }) async {
    try {
      final reply = await _dataSource.sendMessage(userId: userId, text: text);
      return Result.success(reply);
    } on firestore.FirebaseException catch (e) {
      return Result.failure(UnknownFailure(e.message ?? 'Could not send message.'));
    } catch (e) {
      return Result.failure(UnknownFailure('The AI companion is unavailable right now: $e'));
    }
  }
}
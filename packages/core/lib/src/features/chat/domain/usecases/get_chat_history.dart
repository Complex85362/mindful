import '../repositories/chat_repository.dart';
import '../entities/chat_message.dart';
import '../../../../common/result.dart';

class GetChatHistory {
  final ChatRepository repository;
  const GetChatHistory(this.repository);

  Future<Result<List<ChatMessage>>> call(String userId) {
    return repository.getHistory(userId);
  }
}
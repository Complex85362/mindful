import '../repositories/chat_repository.dart';
import '../entities/chat_message.dart';
import '../../../../common/result.dart';

class SendChatMessage {
  final ChatRepository repository;
  const SendChatMessage(this.repository);

  Future<Result<ChatMessage>> call({required String userId, required String text}) {
    return repository.sendMessage(userId: userId, text: text);
  }
}
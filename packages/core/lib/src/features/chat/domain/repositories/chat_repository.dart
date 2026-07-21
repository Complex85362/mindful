import '../entities/chat_message.dart';
import '../../../../common/result.dart';

abstract class ChatRepository {
  Future<Result<List<ChatMessage>>> getHistory(String userId);

  /// Persists the user's message, sends it to Gemini with prior history as
  /// context, persists the model's reply, and returns that reply.
  Future<Result<ChatMessage>> sendMessage({
    required String userId,
    required String text,
  });
}
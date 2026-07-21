import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  final GetChatHistory _getChatHistory;
  final SendChatMessage _sendChatMessage;

  ChatProvider({
    required GetChatHistory getChatHistory,
    required SendChatMessage sendChatMessage,
  })  : _getChatHistory = getChatHistory,
        _sendChatMessage = sendChatMessage;

  List<ChatMessage> _messages = [];
  bool _isLoadingHistory = false;
  bool _isSending = false;
  String? _errorMessage;
  bool _hasLoaded = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<void> loadHistory(String userId) async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    _isLoadingHistory = true;
    notifyListeners();

    final result = await _getChatHistory(userId);
    result.fold(
          (failure) => _errorMessage = failure.message,
          (messages) => _messages = messages,
    );

    _isLoadingHistory = false;
    notifyListeners();
  }

  Future<void> sendMessage({required String userId, required String text}) async {
    if (text.trim().isEmpty) return;

    // Optimistic: show the user's own message immediately, don't wait on
    // Gemini's round trip to render it. Same pattern as FavoritesProvider.
    final optimisticUserMessage = ChatMessage(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      userId: userId,
      role: ChatRole.user,
      text: text,
      sentAt: DateTime.now(),
    );
    _messages = [..._messages, optimisticUserMessage];
    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _sendChatMessage(userId: userId, text: text);
    result.fold(
          (failure) {
        _errorMessage = failure.message;
        _isSending = false;
        notifyListeners();
      },
          (reply) {
        _messages = [..._messages, reply];
        _isSending = false;
        notifyListeners();
      },
    );
  }
}
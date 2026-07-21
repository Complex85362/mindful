enum ChatRole { user, model }

class ChatMessage {
  final String id;
  final String userId;
  final ChatRole role;
  final String text;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.userId,
    required this.role,
    required this.text,
    required this.sentAt,
  });
}
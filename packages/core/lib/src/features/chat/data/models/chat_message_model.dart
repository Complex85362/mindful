import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.userId,
    required super.role,
    required super.text,
    required super.sentAt,
  });

  factory ChatMessageModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatMessageModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      role: (data['role'] as String?) == 'model' ? ChatRole.model : ChatRole.user,
      text: data['text'] as String? ?? '',
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
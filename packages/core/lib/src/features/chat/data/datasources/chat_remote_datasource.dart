import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';

import '../../domain/entities/chat_message.dart';
import '../models/chat_message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore _firestore;
  final GenerativeModel _model;

  ChatRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _model = FirebaseAI.googleAI().generativeModel(
          model: 'gemini-flash-latest',
          systemInstruction: Content.system(
            'You are a calm, supportive wellness companion inside a mindfulness '
                'app called Mindful. Keep responses warm, brief (2-4 sentences '
                'usually), and encouraging. You are not a licensed therapist -- if '
                'someone describes a crisis or serious mental health concern, '
                'gently suggest they reach out to a real professional or a crisis '
                'line, rather than trying to handle it yourself.',
          ),
        );

  CollectionReference<Map<String, dynamic>> _messagesRef(String userId) =>
      _firestore.collection('chat_messages').doc(userId).collection('messages');

  Future<List<ChatMessageModel>> getHistory(String userId) async {
    final snapshot = await _messagesRef(userId).orderBy('sentAt').get();
    return snapshot.docs.map(ChatMessageModel.fromFirestore).toList();
  }

  Future<ChatMessageModel> sendMessage({
    required String userId,
    required String text,
  }) async {
    final now = DateTime.now();

    // 1. Persist the user's message first.
    await _messagesRef(userId).add({
      'userId': userId,
      'role': 'user',
      'text': text,
      'sentAt': Timestamp.fromDate(now),
    });

    // 2. Rebuild prior history as Gemini's Content format, so the model has
    // conversational context rather than treating every message as a fresh,
    // isolated question.
    final priorMessages = await getHistory(userId);
    final history = priorMessages
        .map((m) => Content(m.role == ChatRole.user ? 'user' : 'model', [TextPart(m.text)]))
        .toList();

    // 3. Send to Gemini with that history as context.
    final chat = _model.startChat(history: history);
    final response = await chat.sendMessage(Content.text(text));
    final replyText = response.text ?? "Sorry, I couldn't come up with a response.";

    // 4. Persist the model's reply.
    final replyTimestamp = DateTime.now();
    final replyDoc = await _messagesRef(userId).add({
      'userId': userId,
      'role': 'model',
      'text': replyText,
      'sentAt': Timestamp.fromDate(replyTimestamp),
    });

    return ChatMessageModel(
      id: replyDoc.id,
      userId: userId,
      role: ChatRole.model,
      text: replyText,
      sentAt: replyTimestamp,
    );
  }
}
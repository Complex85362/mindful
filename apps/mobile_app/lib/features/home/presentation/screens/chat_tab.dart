import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId != null) {
        context.read<ChatProvider>().loadHistory(userId);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    // Deferred to after the frame renders, so the list has actually grown
    // before we try to scroll to its new end -- scrolling immediately would
    // target the OLD (shorter) content height.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final userId = context.read<AuthProvider>().currentUser?.uid;
    if (userId == null) return;

    _textController.clear();
    await context.read<ChatProvider>().sendMessage(userId: userId, text: text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: chatProvider.isLoadingHistory
                ? const Center(child: CircularProgressIndicator())
                : chatProvider.messages.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Say hello — I'm here to chat about how you're feeling.",
                  textAlign: TextAlign.center,
                ),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isUser = message.role == ChatRole.user;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          if (chatProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                chatProvider.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ),
          if (chatProvider.isSending)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: chatProvider.isSending ? null : _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
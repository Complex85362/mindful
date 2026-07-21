import 'package:flutter/material.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('AI chatbot — coming soon')),
    );
  }
}
import 'package:flutter/material.dart';

class SavedTab extends StatelessWidget {
  const SavedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: const Center(child: Text('Favorites — coming soon')),
    );
  }
}
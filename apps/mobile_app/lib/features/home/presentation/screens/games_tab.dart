import 'package:flutter/material.dart';

class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: const Center(child: Text('Games & leaderboard — coming soon')),
    );
  }
}
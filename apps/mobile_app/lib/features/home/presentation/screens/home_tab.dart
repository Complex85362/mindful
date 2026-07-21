import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/author_list.dart';
import '../widgets/quote_of_day_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const QuoteOfDayCard(),
            const MoodCheckinCard(),
            Text('Authors', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            const AuthorList(),
            const SizedBox(height: 16),
            Text('Signed in as: ${user?.email ?? "unknown"}'),
          ],
        ),
      ),
    );
  }
}
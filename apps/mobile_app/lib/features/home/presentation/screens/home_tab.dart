import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/book_list.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/content_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/author_list.dart';
import '../widgets/mood_checkin_card.dart';
import '../widgets/quote_of_day_card.dart';
import '../widgets/streak_badge.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<ContentProvider>().loadHomeContent();
      context.read<ContentProvider>().loadHomeContent();
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId != null) {
        context.read<FavoritesProvider>().loadFavorites(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful'),
        actions: [
          const StreakBadge(),
          const SizedBox(width: 8),
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
            Text('Books', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            const BookList(),
            const SizedBox(height: 16),
            Text(
              'Hello, ${user?.displayName?.isNotEmpty == true ? user!.displayName : "there"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
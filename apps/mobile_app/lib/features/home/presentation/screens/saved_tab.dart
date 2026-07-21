import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/content_provider.dart';
import '../providers/favorites_provider.dart';

class SavedTab extends StatefulWidget {
  const SavedTab({super.key});

  @override
  State<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<SavedTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId != null) {
        context.read<FavoritesProvider>().loadFavorites(userId);
      }
      // Guarded by _hasLoaded internally, so calling this again here (even
      // though HomeTab already triggers it) is harmless -- it's a no-op if
      // Home already loaded it first.
      context.read<ContentProvider>().loadHomeContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = context.watch<FavoritesProvider>();
    final contentProvider = context.watch<ContentProvider>();

    if (favoritesProvider.isLoading && favoritesProvider.favorites.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final favoriteAuthors =
    favoritesProvider.favorites.where((f) => f.itemType == 'author').toList();
    final favoriteQuotes =
    favoritesProvider.favorites.where((f) => f.itemType == 'quote').toList();

    if (favoriteAuthors.isEmpty && favoriteQuotes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              "Nothing saved yet. Tap the heart on a quote or author to save it here.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (favoriteAuthors.isNotEmpty) ...[
            Text('Authors', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            ...favoriteAuthors.map((fav) {
              final author = contentProvider.authorById(fav.itemId);
              if (author == null) return const SizedBox.shrink();
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text(author.name[0])),
                  title: Text(author.name),
                  subtitle: Text(author.bio, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                    onPressed: () {
                      final userId = context.read<AuthProvider>().currentUser?.uid;
                      if (userId == null) return;
                      context.read<FavoritesProvider>().toggleFavorite(
                        userId: userId,
                        itemType: 'author',
                        itemId: author.id,
                      );
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
          if (favoriteQuotes.isNotEmpty) ...[
            Text('Quotes', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            ...favoriteQuotes.map((fav) {
              return FutureBuilder<Quote?>(
                future: contentProvider.fetchQuoteById(fav.itemId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(),
                    );
                  }
                  final quote = snapshot.data;
                  if (quote == null) return const SizedBox.shrink();
                  final author = contentProvider.authorById(quote.authorId);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text('"${quote.text}"'),
                      subtitle: author != null ? Text('— ${author.name}') : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.redAccent),
                        onPressed: () {
                          final userId = context.read<AuthProvider>().currentUser?.uid;
                          if (userId == null) return;
                          context.read<FavoritesProvider>().toggleFavorite(
                            userId: userId,
                            itemType: 'quote',
                            itemId: quote.id,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ],
      ),
    );
  }
}
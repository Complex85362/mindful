import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/content_provider.dart';

class QuoteOfDayCard extends StatelessWidget {
  const QuoteOfDayCard({super.key});

  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();
    final quote = contentProvider.quoteOfTheDay;

    if (quote == null) return const SizedBox.shrink();

    final author = contentProvider.authorById(quote.authorId);
    final isFavorited = favoritesProvider.isFavorited('quote', quote.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quote of the Day', style: Theme.of(context).textTheme.labelLarge),
                IconButton(
                  icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
                  color: isFavorited ? Colors.redAccent : null,
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
              ],
            ),
            Text('"${quote.text}"', style: Theme.of(context).textTheme.bodyLarge),
            if (author != null) ...[
              const SizedBox(height: 8),
              Text('— ${author.name}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/content_provider.dart';

class QuoteOfDayCard extends StatelessWidget {
  const QuoteOfDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();
    final quote = contentProvider.quoteOfTheDay;

    if (quote == null) return const SizedBox.shrink();

    final author = contentProvider.authorById(quote.authorId);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quote of the Day', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
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
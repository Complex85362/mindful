import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/content_provider.dart';

class AuthorList extends StatelessWidget {
  const AuthorList({super.key});

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();

    if (contentProvider.isLoading && contentProvider.authors.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contentProvider.authors.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.authors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final author = contentProvider.authors[index];
          return SizedBox(
            width: 72,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage:
                  author.imageUrl != null ? NetworkImage(author.imageUrl!) : null,
                  child: author.imageUrl == null ? Text(author.name[0]) : null,
                ),
                const SizedBox(height: 6),
                Text(
                  author.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
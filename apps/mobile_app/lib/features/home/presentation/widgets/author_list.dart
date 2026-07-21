import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/content_provider.dart';
import '../providers/favorites_provider.dart';

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
          final favoritesProvider = context.watch<FavoritesProvider>();
          final isFavorited = favoritesProvider.isFavorited('author', author.id);

          return SizedBox(
            width: 72,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage:
                      author.imageUrl != null ? NetworkImage(author.imageUrl!) : null,
                      child: author.imageUrl == null ? Text(author.name[0]) : null,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: GestureDetector(
                        onTap: () {
                          final userId = context.read<AuthProvider>().currentUser?.uid;
                          if (userId == null) return;
                          context.read<FavoritesProvider>().toggleFavorite(
                            userId: userId,
                            itemType: 'author',
                            itemId: author.id,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorited ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
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
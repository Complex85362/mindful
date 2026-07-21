import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/content_provider.dart';

class BookList extends StatelessWidget {
  const BookList({super.key});

  Future<void> _openBook(BuildContext context, String? pdfUrl) async {
    if (pdfUrl == null || pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No PDF available for this book yet.')),
      );
      return;
    }
    final uri = Uri.parse(pdfUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this book.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentProvider = context.watch<ContentProvider>();

    if (contentProvider.isLoading && contentProvider.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (contentProvider.books.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: contentProvider.books.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final book = contentProvider.books[index];
          final author = contentProvider.authorById(book.authorId);

          return GestureDetector(
            onTap: () => _openBook(context, book.pdfUrl),
            child: SizedBox(
              width: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.menu_book_outlined, size: 36),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (author != null)
                    Text(
                      author.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
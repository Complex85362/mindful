class Book {
  final String id;
  final String authorId;
  final String title;
  final String? pdfUrl;

  const Book({
    required this.id,
    required this.authorId,
    required this.title,
    this.pdfUrl,
  });
}
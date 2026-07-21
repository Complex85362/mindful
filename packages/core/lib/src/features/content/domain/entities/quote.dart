class Quote {
  final String id;
  final String authorId;
  final String categoryId;
  final String text;
  final String? moodTag;

  const Quote({
    required this.id,
    required this.authorId,
    required this.categoryId,
    required this.text,
    this.moodTag,
  });
}
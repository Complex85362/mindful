class Author {
  final String id;
  final String categoryId;
  final String name;
  final String? imageUrl;
  final String bio;

  const Author({
    required this.id,
    required this.categoryId,
    required this.name,
    this.imageUrl,
    required this.bio,
  });
}
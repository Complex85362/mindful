class Favorite {
  final String id;
  final String userId;
  final String itemType; // 'quote' or 'author'
  final String itemId;

  const Favorite({
    required this.id,
    required this.userId,
    required this.itemType,
    required this.itemId,
  });
}
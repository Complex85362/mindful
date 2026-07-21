class MoodLog {
  final String id;
  final String userId;
  final String mood;
  final DateTime loggedAt;

  const MoodLog({
    required this.id,
    required this.userId,
    required this.mood,
    required this.loggedAt,
  });
}
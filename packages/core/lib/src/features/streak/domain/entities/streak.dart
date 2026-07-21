class Streak {
  final String userId;
  final int currentStreak;
  final DateTime? lastActiveDate;

  const Streak({
    required this.userId,
    required this.currentStreak,
    this.lastActiveDate,
  });
}
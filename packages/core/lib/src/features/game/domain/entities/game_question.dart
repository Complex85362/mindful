class GameQuestion {
  final String id;
  final String categoryId;
  final String authorId;
  final String mode;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const GameQuestion({
    required this.id,
    required this.categoryId,
    required this.authorId,
    required this.mode,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/game_provider.dart';

class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<GameProvider>().loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: switch (gameProvider.phase) {
          QuizPhase.idle => _IdleView(gameProvider: gameProvider),
          QuizPhase.playing => _QuizView(gameProvider: gameProvider),
          QuizPhase.finished => _ResultsView(gameProvider: gameProvider),
        },
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  final GameProvider gameProvider;
  const _IdleView({required this.gameProvider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        gameProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(
          onPressed: () => gameProvider.startQuiz(),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Start Quiz'),
          ),
        ),
        if (gameProvider.errorMessage != null) ...[
          const SizedBox(height: 12),
          Text(
            gameProvider.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        Text('Leaderboard', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        if (gameProvider.leaderboard.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No scores yet — be the first!'),
          )
        else
          ...gameProvider.leaderboard.asMap().entries.map((entry) {
            final rank = entry.key + 1;
            final leaderEntry = entry.value;
            return ListTile(
              leading: CircleAvatar(child: Text('$rank')),
              title: Text(leaderEntry.displayName),
              trailing: Text(
                '${leaderEntry.score}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }),
      ],
    );
  }
}

class _QuizView extends StatelessWidget {
  final GameProvider gameProvider;
  const _QuizView({required this.gameProvider});

  @override
  Widget build(BuildContext context) {
    final question = gameProvider.currentQuestion;
    if (question == null) return const Center(child: CircularProgressIndicator());

    final selected = gameProvider.selectedAnswerIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${gameProvider.currentIndex + 1} of ${gameProvider.questions.length}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Text(question.question, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        ...List.generate(question.options.length, (index) {
          final isSelected = selected == index;
          final isCorrectOption = index == question.correctAnswerIndex;

          Color? backgroundColor;
          if (selected != null) {
            if (isCorrectOption) {
              backgroundColor = Colors.green.withValues(alpha: 0.25);
            } else if (isSelected) {
              backgroundColor = Colors.red.withValues(alpha: 0.25);
            }
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              style: backgroundColor != null
                  ? ElevatedButton.styleFrom(backgroundColor: backgroundColor)
                  : null,
              onPressed: selected == null ? () => gameProvider.answerQuestion(index) : null,
              child: Text(question.options[index]),
            ),
          );
        }),
        const Spacer(),
        if (selected != null)
          ElevatedButton(
            onPressed: () async {
              gameProvider.nextQuestion();
              if (gameProvider.phase == QuizPhase.finished) {
                final authProvider = context.read<AuthProvider>();
                final userId = authProvider.currentUser?.uid;
                final displayName = authProvider.currentUser?.displayName ?? 'Anonymous';
                if (userId != null) {
                  await gameProvider.submitScore(userId: userId, displayName: displayName);
                }
              }
            },
            child: Text(
              gameProvider.currentIndex < gameProvider.questions.length - 1 ? 'Next' : 'Finish',
            ),
          ),
      ],
    );
  }
}

class _ResultsView extends StatelessWidget {
  final GameProvider gameProvider;
  const _ResultsView({required this.gameProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Quiz complete!', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Score: ${gameProvider.score}', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => gameProvider.resetQuiz(),
          child: const Text('Back to Games'),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/mood_provider.dart';

/// Handles its own lifecycle (fetching latest mood) independently of
/// HomeTab, which stays a simple StatelessWidget. Keeping this fetch logic
/// local to the widget that actually needs it, rather than pushing it up
/// into HomeTab, means HomeTab doesn't have to know or care that mood
/// check-in exists internally -- it just places this widget on the screen.
class MoodCheckinCard extends StatefulWidget {
  const MoodCheckinCard({super.key});

  @override
  State<MoodCheckinCard> createState() => _MoodCheckinCardState();
}

class _MoodCheckinCardState extends State<MoodCheckinCard> {
  static const _moods = {
    'happy': '🙂 Happy',
    'calm': '😌 Calm',
    'sad': '😔 Sad',
    'anxious': '😰 Anxious',
  };

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId != null) {
        context.read<MoodProvider>().checkLatestMood(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = context.watch<MoodProvider>();

    // Collapsed state: already checked in today -- per spec, this collapses
    // into a small chip instead of showing the full prompt again.
    if (moodProvider.hasCheckedInToday) {
      final label = _moods[moodProvider.latestMood!.mood] ?? moodProvider.latestMood!.mood;
      return Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Text("Today's mood: ", style: TextStyle(fontWeight: FontWeight.w600)),
              Text(label),
            ],
          ),
        ),
      );
    }

    // Expanded state: prompt with mood chips.
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling right now?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            if (moodProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moods.entries.map((entry) {
                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: false,
                    onSelected: (_) async {
                      final userId = context.read<AuthProvider>().currentUser?.uid;
                      if (userId == null) return;
                      await context.read<MoodProvider>().logMood(
                        userId: userId,
                        mood: entry.key,
                      );
                    },
                  );
                }).toList(),
              ),
            if (moodProvider.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                moodProvider.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
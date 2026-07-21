import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class PreferencesScreen extends StatefulWidget {
  final String userId;
  const PreferencesScreen({super.key, required this.userId});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred with a microtask rather than called directly: calling a
    // notifyListeners()-triggering method synchronously inside initState
    // can fire before the widget tree has finished its first build pass.
    // Scheduling it lets that first frame complete cleanly first.
    Future.microtask(() {
      if (!mounted) return;
      context.read<PreferencesProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('What brings you here?'),
        automaticallyImplyLeading: false, // no back button -- this step is mandatory
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Pick a few topics you're interested in — we'll use these to personalize your feed.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: prefsProvider.categories.isEmpty && prefsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: prefsProvider.categories.map((category) {
                      final isSelected =
                      prefsProvider.selectedCategoryIds.contains(category.id);
                      return FilterChip(
                        label: Text(category.name),
                        selected: isSelected,
                        onSelected: (_) =>
                            context.read<PreferencesProvider>().toggleCategory(category.id),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (prefsProvider.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  prefsProvider.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              prefsProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () =>
                    context.read<PreferencesProvider>().savePreferences(widget.userId),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
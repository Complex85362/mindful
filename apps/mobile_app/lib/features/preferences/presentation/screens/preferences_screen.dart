import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/preferences_provider.dart';

class PreferencesScreen extends StatefulWidget {
  final String userId;
  /// True when opened from Profile to edit existing choices -- shows a
  /// back button, pre-loads current selections, and pops on save instead
  /// of relying on PreferencesGate to route away.
  final bool isEditing;

  const PreferencesScreen({super.key, required this.userId, this.isEditing = false});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final provider = context.read<PreferencesProvider>();
      provider.loadCategories();
      if (widget.isEditing) {
        provider.loadExistingSelections(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefsProvider = context.watch<PreferencesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit preferences' : "What brings you here?"),
        automaticallyImplyLeading: widget.isEditing, // no back button during mandatory onboarding
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
                onPressed: () async {
                  final success =
                  await context.read<PreferencesProvider>().savePreferences(widget.userId);
                  if (success && widget.isEditing && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(widget.isEditing ? 'Save changes' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
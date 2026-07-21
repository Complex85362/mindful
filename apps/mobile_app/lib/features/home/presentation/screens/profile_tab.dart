

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../preferences/presentation/screens/preferences_screen.dart';
import '../providers/notification_settings_provider.dart';
import '../providers/streak_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {


  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().currentUser?.uid;
      if (userId != null) {
        context.read<StreakProvider>().loadStreak(userId);
      }
      context.read<NotificationSettingsProvider>().load();
    });
  }



  Future<void> _editDisplayName() async {
    final authProvider = context.read<AuthProvider>();
    final controller = TextEditingController(text: authProvider.currentUser?.displayName ?? '');

    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Display name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty || !mounted) return;

    final ok = await authProvider.updateDisplayName(newName);
    if (!mounted) return;
    if (!ok && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(authProvider.errorMessage!)));
    }
  }

  void _editPreferences(String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PreferencesScreen(userId: userId, isEditing: true),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AuthProvider>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final streakProvider = context.watch<StreakProvider>();
    final notificationSettings = context.watch<NotificationSettingsProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 44,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _editDisplayName,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user.displayName?.isNotEmpty == true ? user.displayName! : 'Add your name',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.edit, size: 15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(user.email, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_fire_department_outlined),
              title: const Text('Current streak'),
              trailing: Text(
                '${streakProvider.currentStreak} day${streakProvider.currentStreak == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Preferences', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.tune),
              title: const Text('Categories'),
              subtitle: const Text('Edit the topics used to personalize your feed'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _editPreferences(user.uid),
            ),
          ),
          const SizedBox(height: 20),
          Text('Notifications', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.bedtime_outlined),
                  title: const Text('Daily mood check-in'),
                  subtitle: const Text('Reminder time'),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: notificationSettings.checkInTime,
                      );
                      if (picked != null) {
                        await context.read<NotificationSettingsProvider>().setCheckInTime(picked);
                      }
                    },
                    child: Text(notificationSettings.checkInTime.format(context)),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.auto_awesome_outlined),
                  title: const Text('Mood-based quote alerts'),
                  value: notificationSettings.moodQuoteAlertsEnabled,
                  onChanged: (value) =>
                      context.read<NotificationSettingsProvider>().setMoodQuoteAlertsEnabled(value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          OutlinedButton.icon(
            onPressed: _confirmSignOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error.withOpacity(0.4)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
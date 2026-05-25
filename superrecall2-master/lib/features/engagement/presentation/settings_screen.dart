import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/settings_controller.dart';
import '../state/notification_controller.dart';
import '../../study/state/progress_controller.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/remote/sync_service.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final settings = context.watch<SettingsController>();
    final notifications = context.watch<NotificationController>();
    final progress = context.watch<ProgressController>();

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionHeader(title: 'Account & Goal'),
          ListTile(
            title: const Text('Exam Preparation Goal'),
            subtitle: Text('${progress.monthsToGoal} ${progress.monthsToGoal == 1 ? 'Month' : 'Months'} Plan'),
            trailing: Icon(Icons.chevron_right_rounded, color: colors.textMuted),
            onTap: () => _showGoalPicker(context, progress),
          ),
          Divider(color: colors.borderSubtle),
          _SectionHeader(title: 'Sync & Identity'),
          ListTile(
            title: const Text('Cloud Profile & Security'),
            subtitle: const Text('Secure your progress with an account'),
            leading: Icon(Icons.cloud_sync_rounded, color: colors.accentPrimary),
            trailing: Icon(Icons.chevron_right_rounded, color: colors.textMuted),
            onTap: () => context.push('/profile'),
          ),
          Divider(color: colors.borderSubtle),
          _SectionHeader(title: 'AI Tutoring'),
          ListTile(
            title: const Text('Gemini API Key'),
            subtitle: Text(settings.geminiApiKey == null || settings.geminiApiKey!.isEmpty
                ? 'Not configured (using Mock mode)'
                : '••••••••••••••••'),
            trailing: Icon(Icons.vpn_key_rounded, color: colors.textMuted),
            onTap: () => _showApiKeyDialog(context, settings),
          ),
          Divider(color: colors.borderSubtle),
          _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            title: const Text('Smart Reminders'),
            subtitle: const Text('Get alerts for due reviews and streaks'),
            value: notifications.remindersEnabled,
            activeThumbColor: colors.accentPrimary,
            onChanged: (val) => notifications.toggleReminders(val),
          ),
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text('Current: ${settings.reminderTime.format(context)}'),
            trailing: Icon(Icons.access_time_rounded, color: colors.textMuted),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: settings.reminderTime,
              );
              if (time != null) {
                settings.setReminderTime(time);
              }
            },
          ),
          Divider(color: colors.borderSubtle),
          _SectionHeader(title: 'Data Management'),
          ListTile(
            title: const Text('Reset All Progress'),
            subtitle: const Text('This will clear all local study data'),
            textColor: colors.accentDanger,
            onTap: () => _showResetDialog(context),
          ),
          const SizedBox(height: 60),
          Center(
            child: Text(
              'SuperRecall v1.2.0\nMade with ❤️ for Bankers',
              textAlign: TextAlign.center,
              style: textTheme.labelSmall?.copyWith(color: colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  void _showGoalPicker(BuildContext context, ProgressController progress) {
    final colors = context.appColors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Adjust Study Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            for (var i in [1, 3, 6, 9, 12])
              ListTile(
                title: Text('$i ${i == 1 ? 'Month' : 'Months'}'),
                onTap: () {
                  progress.setMonthsToGoal(i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, SettingsController settings) {
    final controller = TextEditingController(text: settings.geminiApiKey);
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        title: const Text('Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your Google Gemini API Key to enable live AI tutoring.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.accentPrimary)),
                hintText: 'Enter key...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: colors.textSecondary))),
          FilledButton(
            onPressed: () {
              settings.setGeminiApiKey(controller.text);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: colors.accentPrimary),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        title: const Text('Reset All Data?'),
        content: const Text('This action cannot be undone. You will lose all streaks, XP, and SRS intervals.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: TextStyle(color: colors.textSecondary))),
          TextButton(
            onPressed: () async {
              final sync = context.read<SyncService>();
              await context.read<StorageService>().clearAll();
              await sync.signOut();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data has been reset successfully.')));
              }
            },
            child: Text('Reset', style: TextStyle(color: colors.accentDanger)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colors.accentPrimary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

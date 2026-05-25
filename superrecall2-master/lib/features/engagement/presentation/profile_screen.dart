import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../data/remote/sync_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = context.watch<SyncService>();
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            CircleAvatar(
              radius: 50,
              backgroundColor: colors.accentPrimary,
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              syncService.userEmail ?? 'Anonymous Hero',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  syncService.isAnonymous ? Icons.warning_amber_rounded : Icons.verified_user,
                  size: 16,
                  color: syncService.isAnonymous ? colors.accentWarning : colors.accentSuccess,
                ),
                const SizedBox(width: 4),
                Text(
                  syncService.isAnonymous ? 'Unsecured Account' : 'Cloud Verified',
                  style: textTheme.bodySmall?.copyWith(
                    color: syncService.isAnonymous ? colors.accentWarning : colors.accentSuccess,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxxl),
            
            if (syncService.isAnonymous)
              _buildCard(
                context: context,
                title: 'Secure Your Progress',
                subtitle: 'Link an email account to sync across devices and prevent data loss.',
                icon: Icons.cloud_upload_outlined,
                actionLabel: 'Link Now',
                onTap: () => context.push('/auth?linking=true'),
                isPrimary: true,
              ),
              
            const SizedBox(height: AppSpacing.lg),
            
            _buildCard(
              context: context,
              title: 'Data Synchronization',
              subtitle: 'Last synced with cloud (Simulated)',
              icon: Icons.sync_rounded,
              actionLabel: 'Sync Now',
              onTap: () async {
                await syncService.pullRemoteProgress();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progress synchronized!')),
                  );
                }
              },
            ),
            
            const SizedBox(height: AppSpacing.xxxl),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await syncService.signOut();
                  if (context.mounted) Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.accentDanger,
                  side: BorderSide(color: colors.accentDanger),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String actionLabel,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isPrimary ? colors.accentPrimary.withValues(alpha: 0.3) : colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.accentPrimary),
              const SizedBox(width: AppSpacing.md),
              Text(title, style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(subtitle, style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: isPrimary ? colors.accentPrimary : colors.surfaceBase,
                foregroundColor: isPrimary ? Colors.white : colors.accentPrimary,
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

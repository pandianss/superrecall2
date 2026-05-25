import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../study/domain/learning_models.dart';
import '../../study/state/progress_controller.dart';
import '../../study/state/srs_controller.dart';
import '../state/analytics_extensions.dart';
import '../state/engagement_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({super.key, required this.exam});

  final ExamCatalog exam;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressController>();
    final srs = context.watch<SrsController>();
    final engagement = context.watch<EngagementController>();
    final colors = context.appColors;
    final theme = Theme.of(context);
    
    final subjectMastery = progress.getSubjectMastery(exam);
    final srsInventory = srs.getSrsInventory(exam);
    final activity = engagement.getRecentActivity(14);

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        title: const Text('Learning Insights'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(context, engagement),
                const SizedBox(height: AppSpacing.xxl),
                
                Text('Subject Mastery', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                _MasteryList(mastery: subjectMastery),
                
                const SizedBox(height: AppSpacing.xxl),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Retention Funnel', style: theme.textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.md),
                          _SrsFunnel(inventory: srsInventory),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xl),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Study Velocity', style: theme.textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.md),
                          _ActivityLineChart(activity: activity),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, EngagementController engagement) {
    final metrics = engagement.metrics;
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Current Streak',
            value: '${metrics.currentStreak} Days',
            icon: Icons.local_fire_department,
            color: colors.accentWarning,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'Total Experience',
            value: '${metrics.totalXp} XP',
            icon: Icons.stars,
            color: colors.accentPrimary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            label: 'Global Level',
            value: 'Level ${metrics.level}',
            icon: Icons.workspace_premium,
            color: Colors.amber[700]!,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppSpacing.md),
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: colors.textMuted)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _MasteryList extends StatelessWidget {
  const _MasteryList({required this.mastery});
  final List<SubjectMastery> mastery;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: mastery.map((m) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: colors.surfaceCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(m.subjectName, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    '${(m.completionPercent * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: colors.accentPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: m.completionPercent,
                  minHeight: 12,
                  backgroundColor: colors.accentPrimary.withValues(alpha: 0.1),
                  color: colors.accentPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${m.completedLessons} of ${m.totalLessons} lessons completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _SrsFunnel extends StatelessWidget {
  const _SrsFunnel({required this.inventory});
  final SrsInventory inventory;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        children: [
          _FunnelLevel(label: 'Mastered', count: inventory.mastered, total: inventory.total, color: colors.accentSuccess),
          _FunnelLevel(label: 'Review', count: inventory.review, total: inventory.total, color: colors.accentWarning),
          _FunnelLevel(label: 'Learning', count: inventory.learning, total: inventory.total, color: colors.accentPrimary),
          _FunnelLevel(label: 'Unseen', count: inventory.total - (inventory.learning + inventory.review + inventory.mastered), total: inventory.total, color: colors.textMuted),
        ],
      ),
    );
  }
}

class _FunnelLevel extends StatelessWidget {
  const _FunnelLevel({required this.label, required this.count, required this.total, required this.color});
  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final widthFactor = total == 0 ? 0.0 : (count / total).clamp(0.1, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.textSecondary))),
          Expanded(
            child: Stack(
              children: [
                Container(height: 32, decoration: BoxDecoration(color: colors.surfaceBase, borderRadius: BorderRadius.circular(8))),
                FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 8),
                    child: Text('$count', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityLineChart extends StatelessWidget {
  const _ActivityLineChart({required this.activity});
  final List<MapEntry<DateTime, int>> activity;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 240,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: CustomPaint(
        painter: _LineChartPainter(activity: activity, colors: colors),
        child: Container(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<MapEntry<DateTime, int>> activity;
  final AppColors colors;
  _LineChartPainter({required this.activity, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    if (activity.isEmpty) return;

    final paint = Paint()
      ..color = colors.accentPrimary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colors.accentPrimary.withValues(alpha: 0.3), colors.accentPrimary.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final maxVal = activity.map((e) => e.value).reduce(math.max);
    final effectiveMax = maxVal == 0 ? 100.0 : maxVal.toDouble();
    
    final path = Path();
    final fillPath = Path();
    
    final dx = size.width / (activity.length - 1);
    
    for (int i = 0; i < activity.length; i++) {
      final x = i * dx;
      final y = size.height - (activity[i].value / effectiveMax) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
      
      if (i == activity.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()..color = colors.accentPrimary;
    for (int i = 0; i < activity.length; i++) {
      final x = i * dx;
      final y = size.height - (activity[i].value / effectiveMax) * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

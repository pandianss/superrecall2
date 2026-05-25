import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/learning_models.dart';
import '../state/learning_session_controller.dart';
import '../../engagement/state/engagement_controller.dart';
import '../../engagement/domain/engagement_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/study_card.dart';

class StudyTab extends StatelessWidget {
  const StudyTab({super.key, required this.selectedExam});
  final ExamCatalog selectedExam;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final sessionController = context.watch<LearningSessionController>();
    final engagement = context.watch<EngagementController>();
    
    final queue = sessionController.getDailyQueue(selectedExam);
    final completedCount = sessionController.getCompletedCountToday(selectedExam);
    final totalDailyGoal = queue.length + completedCount;
    final progress = totalDailyGoal > 0 ? completedCount / totalDailyGoal : 0.0;
    
    // Estimate time: ~30s per card, 5m per lesson
    int estimatedMinutes = 0;
    for (final item in queue) {
      if (item.type == DailyItemType.lesson) {
        estimatedMinutes += item.lesson?.durationMinutes ?? 5;
      } else {
        estimatedMinutes += (item.quiz?.questionCount ?? 5) * 1; // 1 min for quiz roughly
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StudyHeader(metrics: engagement.metrics),
          const SizedBox(height: 32),
          Text('Daily Progress', style: textTheme.displaySmall),
          const SizedBox(height: 16),
          StudyCard(
            child: Row(
              children: [
                _ProgressRing(progress: progress),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        queue.isEmpty ? 'All caught up!' : '$completedCount of $totalDailyGoal items done',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        queue.isEmpty ? 'Next review scheduled for tomorrow' : '~ $estimatedMinutes min to finish',
                        style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (queue.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  context.push('/daily-session/${selectedExam.id}');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colors.accentPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow_rounded),
                    SizedBox(width: 8),
                    Text('Start Daily Session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 32),
          Text('Focus Areas', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          // Short list of weak topics or upcoming reviews
          ...queue.take(3).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StudyCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.accentPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item.type == DailyItemType.lesson ? Icons.menu_book_rounded : Icons.quiz_rounded,
                      color: colors.accentPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type == DailyItemType.lesson ? item.lesson!.title : item.quiz!.title,
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          item.reason,
                          style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class _StudyHeader extends StatelessWidget {
  const _StudyHeader({required this.metrics});
  final EngagementMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back', style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
            Text('Level ${metrics.level}', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            _Badge(
              icon: Icons.bolt_rounded,
              label: '${metrics.totalXp}',
              color: colors.accentWarning,
            ),
            const SizedBox(width: 8),
            _Badge(
              icon: Icons.local_fire_department_rounded,
              label: '${metrics.currentStreak}',
              color: colors.accentDanger,
            ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 8,
            backgroundColor: colors.surfaceElevated,
            valueColor: AlwaysStoppedAnimation<Color>(colors.borderSubtle),
          ),
        ),
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 8,
            strokeCap: StrokeCap.round,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(colors.accentSuccess),
          ),
        ),
        Text(
          '${(progress * 100).round()}%',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

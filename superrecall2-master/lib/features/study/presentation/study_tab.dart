import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../domain/learning_models.dart';
import '../state/learning_session_controller.dart';
import '../state/progress_controller.dart';
import '../../engagement/state/engagement_controller.dart';
import '../../engagement/domain/engagement_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/logger.dart';
import '../../../core/widgets/study_card.dart';

class StudyTab extends StatefulWidget {
  const StudyTab({super.key, required this.selectedExam});
  final ExamCatalog selectedExam;

  @override
  State<StudyTab> createState() => _StudyTabState();
}

class _StudyTabState extends State<StudyTab> {
  bool _hasLoggedView = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoggedView) {
      _hasLoggedView = true;
      _logStudyTabMetrics();
    }
  }

  void _logStudyTabMetrics() {
    final progressController = context.read<ProgressController>();
    final sessionController = context.read<LearningSessionController>();
    final queue = sessionController.getDailyQueue(widget.selectedExam);
    final completedCount = sessionController.getCompletedCountToday(widget.selectedExam);
    final retentionScore = progressController.retentionScoreForExam(widget.selectedExam).round();
    final masteryPercent = progressController.averageMasteryForExam(widget.selectedExam);
    final weakTopics = progressController.weakTopicCountForExam(widget.selectedExam);
    final weakTopicNames = progressController
      .getWeakTopics(widget.selectedExam)
      .take(3)
      .map((topic) => topic.name)
      .join(', ');
    final totalItems = widget.selectedExam.subjects.fold<int>(0, (subjectSum, subject) {
      return subjectSum + subject.modules.fold<int>(0, (moduleSum, module) {
        return moduleSum + module.topics.fold<int>(0, (topicSum, topic) {
          return topicSum + topic.lessons.length + topic.quizzes.length;
        });
      });
    });
    final coveragePercent = totalItems > 0
        ? (progressController.completedCoverageForExam(widget.selectedExam) / totalItems * 100).round()
        : 0;

    AppLogger.logScreenView('study_tab', {
      'exam_id': widget.selectedExam.id,
      'retention_score': retentionScore,
      'mastery_percent': masteryPercent,
      'coverage_percent': coveragePercent,
      'weak_topics': weakTopics,
      'weak_topic_names': weakTopicNames,
      'queue_length': queue.length,
      'completed_today': completedCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final sessionController = context.watch<LearningSessionController>();
    final engagement = context.watch<EngagementController>();
    
    final progressController = context.watch<ProgressController>();
    final queue = sessionController.getDailyQueue(widget.selectedExam);
    final completedCount = sessionController.getCompletedCountToday(widget.selectedExam);
    final totalDailyGoal = queue.length + completedCount;
    final progress = totalDailyGoal > 0 ? completedCount / totalDailyGoal : 0.0;
    final retentionScore = progressController.retentionScoreForExam(widget.selectedExam).round();
    final masteryPercent = progressController.averageMasteryForExam(widget.selectedExam);
    final weakTopics = progressController.weakTopicCountForExam(widget.selectedExam);
    final weakTopicsList = progressController.getWeakTopics(widget.selectedExam);
    final totalItems = widget.selectedExam.subjects.fold<int>(0, (subjectSum, subject) {
      return subjectSum + subject.modules.fold<int>(0, (moduleSum, module) {
        return moduleSum + module.topics.fold<int>(0, (topicSum, topic) {
          return topicSum + topic.lessons.length + topic.quizzes.length;
        });
      });
    });
    final coveragePercent = totalItems > 0
        ? (progressController.completedCoverageForExam(widget.selectedExam) / totalItems * 100).round()
        : 0;

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
          const SizedBox(height: 20),
          _RetentionSummary(
            score: retentionScore,
            mastery: masteryPercent,
            coverage: coveragePercent,
            weakTopics: weakTopics,
          ),
          const SizedBox(height: 28),
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
            Semantics(
              button: true,
              label: 'Start daily session',
              hint: 'Continue your scheduled review and new items for ${widget.selectedExam.name}',
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    AppLogger.logEvent('study_daily_session_start', {
                      'exam_id': widget.selectedExam.id,
                      'queue_length': queue.length,
                      'retention_score': retentionScore,
                      'weak_topics': weakTopics,
                    });
                    context.push('/daily-session/${widget.selectedExam.id}');
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
            ),
          const SizedBox(height: 32),
          Text('Focus Areas', style: textTheme.titleLarge),
          const SizedBox(height: 16),
          if (weakTopicsList.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: weakTopicsList.take(4).map((topic) {
                return Semantics(
                  label: 'Weak topic ${topic.name}',
                  child: Chip(
                    backgroundColor: colors.surfaceElevated,
                    label: Text(
                      topic.name,
                      style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            StudyCard(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Text(
                'No weak topics detected yet. Keep studying and the app will continue to surface exactly what you need next.',
                style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
            ),
          const SizedBox(height: 16),
          // Short list of weak topics or upcoming reviews
          ...queue.take(3).map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Semantics(
              container: true,
              label: '${item.type == DailyItemType.lesson ? 'Lesson' : 'Quiz'} ${item.type == DailyItemType.lesson ? item.lesson!.title : item.quiz!.title} priority item',
              value: item.reason,
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

class _RetentionSummary extends StatelessWidget {
  const _RetentionSummary({required this.score, required this.mastery, required this.coverage, required this.weakTopics});
  final int score;
  final int mastery;
  final int coverage;
  final int weakTopics;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return StudyCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Retention score', style: textTheme.labelSmall?.copyWith(color: colors.textSecondary)),
          const SizedBox(height: 8),
          Text('$score%', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Strength of current recall and next-review readiness', style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Semantics(
                  label: 'Mastery percent',
                  value: '$mastery%',
                  child: _SmallMetric(label: 'Mastery', value: '$mastery%'),
                ),
              ),
              Expanded(
                child: Semantics(
                  label: 'Content coverage',
                  value: '$coverage%',
                  child: _SmallMetric(label: 'Coverage', value: '$coverage%'),
                ),
              ),
              Expanded(
                child: Semantics(
                  label: 'Weak topics count',
                  value: '$weakTopics',
                  child: _SmallMetric(label: 'Weak topics', value: '$weakTopics'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(value, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: textTheme.bodySmall?.copyWith(color: colors.textSecondary)),
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

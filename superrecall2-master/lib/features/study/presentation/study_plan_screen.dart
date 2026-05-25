import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/catalog_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';
import '../../ai/state/ai_quiz_controller.dart';
import '../../ai/presentation/ai_quiz_result_screen.dart';

class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({
    super.key,
    required this.examId,
  });

  final String examId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = context.read<CatalogRepository>();
    final exam = repo.getExam(examId);

    if (exam == null) {
      return const Scaffold(body: Center(child: Text('Exam not found')));
    }

    final progressStore = context.watch<ProgressController>();
    final monthsToGoal = progressStore.monthsToGoal;
    final weeks = monthsToGoal * 4;
    final completedLessons = progressStore.completedLessonsForExam(exam);
    final attemptedQuizzes = progressStore.attemptedQuizzesForExam(exam);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Text('Your study plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16302B),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${exam.name} plan generated',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Built around a $monthsToGoal-month timeline with short daily sessions, recall checks, and spaced review.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.84),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _StatChip(
                            label: 'Daily target',
                            value: '${exam.recommendedDailyMinutes} min',
                          ),
                          _StatChip(
                            label: 'Weekly assessment',
                            value: exam.weeklyAssessmentLabel,
                          ),
                          _StatChip(
                            label: 'Progress',
                            value:
                                '$completedLessons lessons | $attemptedQuizzes quizzes',
                          ),
                          const _StatChip(
                            label: 'Review rhythm',
                            value: '1, 3, 7 day cycle',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _PersonalizedActionPlanCard(exam: exam),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 760;
                    return Flex(
                      direction: stacked ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _PlanOverviewCard(
                            exam: exam,
                            monthsToGoal: monthsToGoal,
                            weeks: weeks,
                          ),
                        ),
                        SizedBox(
                          width: stacked ? 0 : 20,
                          height: stacked ? 20 : 0,
                        ),
                        Expanded(flex: 3, child: _WeeklyRhythmCard(exam: exam)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                _CurriculumExplorerCard(exam: exam),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanOverviewCard extends StatelessWidget {
  const _PlanOverviewCard({
    required this.exam,
    required this.monthsToGoal,
    required this.weeks,
  });

  final ExamCatalog exam;
  final int monthsToGoal;
  final int weeks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan snapshot', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${exam.name} preparation over roughly $weeks weeks, paced for a working learner.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _PlanMetricRow(
            label: 'Daily commitment',
            value: '${exam.recommendedDailyMinutes} minutes',
          ),
          _PlanMetricRow(
            label: 'Subjects mapped',
            value: '${exam.subjects.length}',
          ),
          _PlanMetricRow(
            label: 'Modules mapped',
            value: '${exam.totalModules}',
          ),
          _PlanMetricRow(label: 'Topics mapped', value: '${exam.totalTopics}'),
          _PlanMetricRow(
            label: 'Lessons mapped',
            value: '${exam.totalLessons}',
          ),
          _PlanMetricRow(
            label: 'Quiz sets mapped',
            value: '${exam.totalQuizzes}',
          ),
          _PlanMetricRow(label: 'Timeline', value: '$monthsToGoal months'),
          const SizedBox(height: 20),
          Text('Primary focus areas', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final area in exam.focusAreas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: colors.accentSuccess,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(area, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _WeeklyRhythmCard extends StatelessWidget {
  const _WeeklyRhythmCard({required this.exam});

  final ExamCatalog exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly rhythm', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'A practical cadence based on the report\'s microlearning and retrieval-practice guidance.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          for (var i = 0; i < exam.weeklyRhythm.length; i++)
            _PlanStep(
              index: '0${i + 1}',
              title: exam.weeklyRhythm[i].split(':').first,
              detail: exam.weeklyRhythm[i].split(':').last.trim(),
            ),
        ],
      ),
    );
  }
}

class _CurriculumExplorerCard extends StatelessWidget {
  const _CurriculumExplorerCard({required this.exam});

  final ExamCatalog exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subjects and modules', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Topics can now vary by exam format and notation needs, and lessons can open richer detail screens.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (final subject in exam.subjects) _SubjectTile(subject: subject),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.subject});

  final SubjectCatalog subject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: ExpansionTile(


        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Text(subject.name, style: theme.textTheme.titleMedium),
        subtitle: Text(
          '${subject.description} | ${subject.totalLessons} lessons | ${subject.totalQuizzes} quizzes',
          style: theme.textTheme.bodyMedium,
        ),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final format in subject.examFormats)
                _FormatChip(label: describeExamFormat(format)),
            ],
          ),
          const SizedBox(height: 12),
          for (final module in subject.modules) _ModuleTile(module: module),
          const SizedBox(height: 12),
          _AiGenerateQuizButton(subject: subject),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});

  final ModuleCatalog module;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(module.name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(module.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            '${module.topics.length} topics | ${module.totalLessons} lessons | ${module.totalQuizzes} quizzes',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final topic in module.topics) _TopicCard(topic: topic),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({required this.topic});

  final TopicCatalog topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final progress = context.select<ProgressController, TopicProgress>((p) => p.progressForTopic(topic));

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceBase,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(topic.name, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(topic.summary, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TopicInfoChip(
                icon: Icons.play_circle_outline_rounded,
                label: '${topic.lessons.length} lessons',
              ),
              _TopicInfoChip(
                icon: Icons.quiz_outlined,
                label: '${topic.quizzes.length} quizzes',
              ),
              _TopicInfoChip(
                icon: Icons.insights_rounded,
                label: '${progress.masteryPercent}% mastery',
              ),
              _TopicInfoChip(
                icon: Icons.functions_rounded,
                label: topic.notationSupport ? 'Math ready' : 'Text only',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final format in topic.examFormats)
                _FormatChip(label: describeExamFormat(format)),
            ],
          ),
          const SizedBox(height: 10),
          Text('Topic learning units', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final lesson in topic.lessons) _LessonRow(lesson: lesson),
          for (final quiz in topic.quizzes) _QuizRow(quiz: quiz),
        ],
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson});

  final LessonUnit lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final completed = context.select<ProgressController, bool>((p) => p.isLessonCompleted(lesson.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          context.push('/lesson/${lesson.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 18,
                color: colors.accentPrimary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(lesson.title, style: theme.textTheme.bodyMedium),
              ),
              if (completed)
                Text(
                  'Completed | ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.accentSuccess,
                  ),
                ),
              Text(
                '${lesson.durationMinutes} min | ${describeLearningFormat(lesson.format)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizRow extends StatelessWidget {
  const _QuizRow({required this.quiz});

  final QuizSet quiz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final attempt = context.select<ProgressController, QuizAttemptResult?>((p) => p.quizAttemptFor(quiz.id));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          context.push('/quiz/${quiz.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 18,
                color: colors.accentWarning,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(quiz.title, style: theme.textTheme.bodyMedium),
              ),
              if (attempt != null)
                Text(
                  'Best ${attempt.correctCount}/${attempt.totalQuestions} | ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.accentSuccess,
                  ),
                ),
              Text(
                '${quiz.questionCount} Q | ${describeExamFormat(quiz.examFormat)}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicInfoChip extends StatelessWidget {
  const _TopicInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colors.accentPrimary),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class _FormatChip extends StatelessWidget {
  const _FormatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Chip(
      label: Text(label),
      side: BorderSide(color: colors.borderSubtle),
      backgroundColor: colors.surfaceElevated,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _PlanStep extends StatelessWidget {
  const _PlanStep({
    required this.index,
    required this.title,
    required this.detail,
  });

  final String index;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.accentWarning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              index,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.accentWarning,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(detail, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanMetricRow extends StatelessWidget {
  const _PlanMetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD4E7E4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalizedActionPlanCard extends StatelessWidget {
  const _PersonalizedActionPlanCard({required this.exam});

  final ExamCatalog exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final progressStore = context.watch<ProgressController>();
    final weakTopics = progressStore.getWeakTopics(exam);

    if (weakTopics.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.accentSuccess.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colors.accentSuccess.withValues(alpha: 0.24)),
        ),
        child: Row(
          children: [
            Icon(Icons.stars_rounded, color: colors.accentSuccess),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "You're on a roll! No weak areas detected. Keep up the consistent review to stay on track.",
                style: theme.textTheme.bodyMedium?.copyWith(color: colors.accentSuccess),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.accentDanger.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.accentDanger.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: colors.accentDanger),
              const SizedBox(width: 12),
              Text(
                'Personalized Action Plan',
                style: theme.textTheme.titleLarge?.copyWith(color: colors.accentDanger),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Based on your recent performance, we've identified ${weakTopics.length} areas that need extra attention. We've prioritized these topics in your daily revision queue to ensure long-term retention.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          for (final topic in weakTopics)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.bolt_rounded, color: colors.accentDanger, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Priority: ${topic.name}',
                      style: theme.textTheme.titleMedium,
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

class _AiGenerateQuizButton extends StatelessWidget {
  const _AiGenerateQuizButton({required this.subject});
  final SubjectCatalog subject;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AiQuizController>();
    final colors = context.appColors;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: controller.status == AiQuizStatus.generating
            ? null
            : () async {
                await controller.generatePracticeQuiz(
                  subject: subject.name,
                  examStyle: 'CFA Level 1',
                );
                if (context.mounted && controller.status == AiQuizStatus.success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiQuizResultScreen()),
                  );
                }
              },
        icon: controller.status == AiQuizStatus.generating
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.auto_awesome_rounded, size: 18),
        label: Text(
          controller.status == AiQuizStatus.generating
              ? 'Generating Questions...'
              : 'Generate AI Practice Quiz',
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.accentPrimary,
          side: BorderSide(color: colors.accentPrimary),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

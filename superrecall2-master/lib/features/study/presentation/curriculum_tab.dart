import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/study_card.dart';

class CurriculumTab extends StatelessWidget {
  const CurriculumTab({
    super.key,
    required this.exams,
    required this.selectedExam,
    required this.onExamChanged,
  });

  final List<ExamCatalog> exams;
  final ExamCatalog selectedExam;
  final ValueChanged<ExamCatalog> onExamChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final progressStore = context.watch<ProgressController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Curriculum', style: textTheme.displaySmall),
          const SizedBox(height: 16),
          Text(
            'Explore your syllabus and track your progress across subjects.',
            style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 32),
          Text('Active Exam', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final exam in exams)
                _ExamSelectorChip(
                  label: exam.name,
                  selected: selectedExam.id == exam.id,
                  onTap: () => onExamChanged(exam),
                ),
            ],
          ),
          const SizedBox(height: 32),
          ...selectedExam.subjects.map((subject) {
            final isPurchased = !subject.isPremium || progressStore.isSubjectPurchased(subject.id);
            return _SubjectCard(
              subject: subject,
              isPurchased: isPurchased,
              onPurchase: () => _showPurchaseDialog(context, subject, progressStore),
              onTap: isPurchased ? () {
                context.push('/study-plan/${selectedExam.id}');
              } : null,
            );
          }),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, SubjectCatalog subject, ProgressController progress) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surfaceCard,
        title: Text('Unlock ${subject.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subject.description),
            const SizedBox(height: 16),
            Text(
              'Get lifetime access to all modules, quizzes, and AI insights for this subject.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later', style: TextStyle(color: colors.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              progress.purchaseSubject(subject.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully unlocked ${subject.name}!'))
              );
            },
            style: FilledButton.styleFrom(backgroundColor: colors.accentPrimary),
            child: Text('Buy for \$${subject.price.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }
}

class _ExamSelectorChip extends StatelessWidget {
  const _ExamSelectorChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? colors.accentPrimary : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? colors.accentPrimary : colors.borderSubtle),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.isPurchased,
    this.onPurchase,
    this.onTap,
  });

  final SubjectCatalog subject;
  final bool isPurchased;
  final VoidCallback? onPurchase;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: StudyCard(
        onTap: isPurchased ? onTap : onPurchase,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(subject.name, style: textTheme.titleLarge),
                          if (subject.isPremium && !isPurchased) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.lock_rounded, size: 16, color: colors.accentWarning),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${subject.modules.length} Modules · ${subject.examFormats.map(describeExamFormat).join(', ')}',
                        style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                if (subject.isPremium && !isPurchased)
                  Text(
                    '\$${subject.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: colors.accentPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted),
              ],
            ),
            const SizedBox(height: 20),
            if (isPurchased)
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: 0.0, // Should use real progress from progressStore
                  minHeight: 6,
                  backgroundColor: colors.surfaceBase,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.accentPrimary),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onPurchase,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.accentPrimary,
                    side: BorderSide(color: colors.accentPrimary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Unlock Subject'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

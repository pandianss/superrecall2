import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/study_card.dart';
import 'widgets/paywall_bottom_sheet.dart';

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
          Text('Core Subjects', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          ...selectedExam.subjects.where((s) => s.id == 'abm' || s.id == 'bfm' || s.id == 'abfm' || s.id == 'brbl').map((subject) {
            final isPurchased = !subject.isPremium || progressStore.isSubjectPurchased(subject.id);
            return _SubjectCard(
              subject: subject,
              isPurchased: isPurchased,
              onPurchase: () => _showPurchaseDialog(context, subject, progressStore),
              onTap: () {
                context.push('/study-plan/${selectedExam.id}');
              },
            );
          }),
          const SizedBox(height: 24),
          Text('Elective Subjects', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          ...selectedExam.subjects.where((s) => s.id != 'abm' && s.id != 'bfm' && s.id != 'abfm' && s.id != 'brbl').map((subject) {
            final isPurchased = !subject.isPremium || progressStore.isSubjectPurchased(subject.id);
            return _SubjectCard(
              subject: subject,
              isPurchased: isPurchased,
              onPurchase: () => _showPurchaseDialog(context, subject, progressStore),
              onTap: () {
                context.push('/study-plan/${selectedExam.id}');
              },
            );
          }),
        ],
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, SubjectCatalog subject, ProgressController progress) {
    if (subject.modules.isNotEmpty) {
      final targetModule = subject.modules.length > 1 ? subject.modules[1] : subject.modules.first;
      PaywallBottomSheet.show(context, subject, targetModule);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${subject.name} does not have any modules.'))
      );
    }
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
        onTap: onTap,
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

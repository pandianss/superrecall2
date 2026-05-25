import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';

class LessonDetailScreen extends StatelessWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final progressStore = context.watch<ProgressController>();
    final repo = context.read<CatalogRepository>();
    final lesson = repo.getLesson(lessonId);

    if (lesson == null) {
      return Scaffold(
        backgroundColor: colors.surfaceBase,
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final completed = progressStore.isLessonCompleted(lesson.id);

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(lesson.title, style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.surfaceLearning,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.accentPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          describeLearningFormat(lesson.format).toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.accentPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(lesson.title, style: textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: colors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            '${lesson.durationMinutes} minute read',
                            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                for (final block in lesson.blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _LessonBlockCard(block: block),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: FilledButton(
                    onPressed: completed
                        ? null
                        : () {
                            HapticFeedback.lightImpact();
                            progressStore.markLessonCompleted(lesson.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Great job! Lesson completed.'),
                                backgroundColor: colors.accentSuccess,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accentPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      elevation: 0,
                    ),
                    child: Text(
                      completed ? '✓ LESSON COMPLETED' : 'MARK AS COMPLETE',
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonBlockCard extends StatelessWidget {
  const _LessonBlockCard({required this.block});

  final LessonContentBlock block;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    switch (block.type) {
      case LessonBlockType.paragraph:
        return Text(
          block.content,
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: colors.textPrimary,
          ),
        );
      case LessonBlockType.callout:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surfaceCallout,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.accentSuccess.withValues(alpha: 0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: colors.accentSuccess, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  block.content,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      case LessonBlockType.equation:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              block.content,
              textStyle: textTheme.titleLarge?.copyWith(
                color: colors.accentPrimary,
              ),
            ),
          ),
        );
      case LessonBlockType.table:
        return _TableBlock(content: block.content);
    }
  }
}

class _TableBlock extends StatelessWidget {
  const _TableBlock({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final rows = content.split('|');
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(colors.surfaceLearning),
            dataRowMinHeight: 56,
            dataRowMaxHeight: 80,
            columnSpacing: 24,
            border: TableBorder(
              verticalInside: BorderSide(color: colors.borderSubtle, width: 0.5),
              horizontalInside: BorderSide(color: colors.borderSubtle, width: 0.5),
            ),
            columns: rows.first.split(',').map((header) {
              return DataColumn(
                label: Text(
                  header.trim(),
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              );
            }).toList(),
            rows: rows.skip(1).map((row) {
              final cells = row.split(',');
              return DataRow(
                cells: cells.map((cell) {
                  return DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        cell.trim(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

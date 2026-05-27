import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';

class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? _selectedConfidence;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final progressStore = context.watch<ProgressController>();
    final repo = context.read<CatalogRepository>();
    final lesson = repo.getLesson(widget.lessonId);

    if (lesson == null) {
      return Scaffold(
        backgroundColor: colors.surfaceBase,
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final topic = repo.getTopicForLesson(lesson.id);
    final exam = repo.getExamForLesson(lesson.id);
    final completed = progressStore.isLessonCompleted(lesson.id);
    final wasCompletedBefore = completed && _selectedConfidence == null;

    final totalPages = 2 + lesson.blocks.length;

    LessonUnit? nextLesson;
    if (topic != null) {
      final idx = topic.lessons.indexWhere((l) => l.id == lesson.id);
      if (idx != -1 && idx < topic.lessons.length - 1) {
        nextLesson = topic.lessons[idx + 1];
      }
    }

    QuizSet? firstQuiz;
    if (topic != null && topic.quizzes.isNotEmpty) {
      firstQuiz = topic.quizzes.first;
    }

    return Scaffold(
      backgroundColor: colors.surfaceBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(lesson.title, style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: (totalPages > 1) ? _currentPage / (totalPages - 1) : 1.0,
                  minHeight: 6,
                  backgroundColor: colors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.accentPrimary),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  Widget cardContent;

                  if (index == 0) {
                    cardContent = Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        const SizedBox(height: 24),
                        Text(lesson.title, style: textTheme.displaySmall),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 18, color: colors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              '${lesson.durationMinutes} minute read',
                              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Swipe or click Next to start learning in focused, microlearning concepts.',
                          style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    );
                  } else if (index <= lesson.blocks.length) {
                    final block = lesson.blocks[index - 1];
                    cardContent = Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LessonBlockCard(block: block),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final hasRated = _selectedConfidence != null || wasCompletedBefore;
                    cardContent = SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stars_rounded,
                            size: 80,
                            color: colors.accentSuccess,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Lesson Completed!',
                            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select your recall confidence to schedule reviews:',
                            style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ConfidenceButton(
                                label: 'Hard',
                                subtitle: 'Review in 1d',
                                color: colors.accentDanger,
                                isSelected: _selectedConfidence == 'hard',
                                onTap: hasRated ? null : () {
                                  _rateConfidence(context, progressStore, lesson.id, 'hard', 1);
                                },
                              ),
                              _ConfidenceButton(
                                label: 'Medium',
                                subtitle: 'Review in 3d',
                                color: colors.accentWarning,
                                isSelected: _selectedConfidence == 'medium' || (wasCompletedBefore && _selectedConfidence == null),
                                onTap: hasRated ? null : () {
                                  _rateConfidence(context, progressStore, lesson.id, 'medium', 3);
                                },
                              ),
                              _ConfidenceButton(
                                label: 'Easy',
                                subtitle: 'Review in 7d',
                                color: colors.accentSuccess,
                                isSelected: _selectedConfidence == 'easy',
                                onTap: hasRated ? null : () {
                                  _rateConfidence(context, progressStore, lesson.id, 'easy', 5);
                                },
                              ),
                            ],
                          ),
                          if (hasRated) ...[
                            const SizedBox(height: 32),
                            const Divider(),
                            const SizedBox(height: 20),
                            Text(
                              'Next Recommended Step',
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _NextStepPanel(
                              nextLesson: nextLesson,
                              quiz: firstQuiz,
                              examId: exam?.id ?? '',
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Card(
                      elevation: 4,
                      color: colors.surfaceCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: BorderSide(color: colors.borderSubtle, width: 1.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: cardContent,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(16),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Text(
                    '${_currentPage + 1} of $totalPages',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton.filled(
                    onPressed: _currentPage < totalPages - 1
                        ? () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.accentPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.all(16),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rateConfidence(BuildContext context, ProgressController progress, String lessonId, String rating, int quality) {
    HapticFeedback.mediumImpact();
    setState(() {
      _selectedConfidence = rating;
    });
    progress.markLessonCompleted(lessonId, quality: quality);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Marked as complete. Scheduled review based on "$rating" recall.'),
        backgroundColor: context.appColors.accentSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ConfidenceButton extends StatelessWidget {
  const _ConfidenceButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? color.withValues(alpha: 0.15) 
              : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : colors.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? color : colors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextStepPanel extends StatelessWidget {
  const _NextStepPanel({
    this.nextLesson,
    this.quiz,
    required this.examId,
  });

  final LessonUnit? nextLesson;
  final QuizSet? quiz;
  final String examId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        if (quiz != null) ...[
          _NextStepTile(
            title: 'Take Practice Quiz',
            subtitle: quiz!.title,
            icon: Icons.checklist_rounded,
            color: colors.accentWarning,
            onTap: () {
              context.replace('/quiz/${quiz!.id}');
            },
          ),
          const SizedBox(height: 12),
        ],
        if (nextLesson != null) ...[
          _NextStepTile(
            title: 'Proceed to Next Lesson',
            subtitle: nextLesson!.title,
            icon: Icons.play_circle_outline_rounded,
            color: colors.accentPrimary,
            onTap: () {
              context.replace('/lesson/${nextLesson!.id}');
            },
          ),
          const SizedBox(height: 12),
        ],
        _NextStepTile(
          title: 'Go to Study Plan',
          subtitle: 'Review remaining modules & analytics',
          icon: Icons.assignment_outlined,
          color: colors.textSecondary,
          onTap: () {
            if (examId.isNotEmpty) {
              context.replace('/study-plan/$examId');
            } else {
              context.pop();
            }
          },
        ),
      ],
    );
  }
}

class _NextStepTile extends StatelessWidget {
  const _NextStepTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.textMuted),
          ],
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

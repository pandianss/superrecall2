import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/study_card.dart';

import '../../../data/repositories/catalog_repository.dart';
import '../domain/learning_models.dart';
import '../state/progress_controller.dart';
import '../state/learning_session_controller.dart';
import '../../engagement/state/engagement_controller.dart';
import '../../engagement/state/notification_controller.dart';
import '../../engagement/state/notification_service.dart';
import '../../engagement/presentation/xp_toast.dart';
import '../../ai/presentation/ai_explanation_area.dart';
import 'dart:async';
import '../../../data/local/storage_service.dart';

class DailySessionScreen extends StatefulWidget {
  const DailySessionScreen({super.key, required this.examId, this.initialQueue});

  final String examId;
  final List<DailyQueueItem>? initialQueue;

  @override
  State<DailySessionScreen> createState() => _DailySessionScreenState();
}

class _DailySessionScreenState extends State<DailySessionScreen> {
  late List<DailyQueueItem> _queue;
  int _currentIndex = 0;
  int _currentSubIndex = 0;
  bool _sessionComplete = false;
  final List<int> _activeToasts = [];
  StreamSubscription? _xpSubscription;

  @override
  void dispose() {
    _xpSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final repo = context.read<CatalogRepository>();
    final exam = repo.getExam(widget.examId);
    if (exam == null) {
      _sessionComplete = true;
      _queue = [];
      return;
    }
    final sessionController = context.read<LearningSessionController>();
    _queue = widget.initialQueue ?? sessionController.getDailyQueue(exam);
    if (_queue.isEmpty) {
      _sessionComplete = true;
    }

    // Attempt to restore a saved checkpoint (queue + current index) if present via controller
    final storage = context.read<StorageService>();
    final checkpointRepo = context.read<CatalogRepository>();

    Future.microtask(() async {
      try {
        final chk = await storage.getSessionCheckpoint();
        if (chk != null && chk['examId'] == widget.examId) {
          final restored = sessionController.restoreQueueFromCheckpoint(chk, checkpointRepo);
          if (restored.isNotEmpty) {
            setState(() {
              _queue = restored;
              final idx = (chk['currentIndex'] as int?) ?? 0;
              _currentIndex = (idx >= 0 && idx < _queue.length) ? idx : 0;
              _currentSubIndex = (chk['subIndex'] as int?) ?? 0;
            });
          } else {
            final idx = (chk['currentIndex'] as int?) ?? 0;
            if (idx >= 0 && idx < _queue.length) {
              setState(() {
                _currentIndex = idx;
                _currentSubIndex = (chk['subIndex'] as int?) ?? 0;
              });
            }
          }
        }
      } catch (e) {
        // ignore restore errors silently
      }
    });

    final engagement = context.read<EngagementController>();
    _xpSubscription = engagement.xpEarnedStream.listen((xp) {
      if (mounted) {
        setState(() {
          _activeToasts.add(xp);
        });
      }
    });
  }

  void _nextItem() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _proceedToNext();
    });
  }

  void _proceedToNext() {
    if (_currentIndex < _queue.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _persistSessionCheckpoint();
    } else {
      setState(() {
        _sessionComplete = true;
      });
      _clearSessionCheckpoint();
    }
  }

  Future<void> _persistSessionCheckpoint() async {
    try {
      final storage = context.read<StorageService>();
      final sessionController = context.read<LearningSessionController>();
      await sessionController.saveCheckpoint(storage, widget.examId, _queue, _currentIndex, _currentSubIndex);
    } catch (_) {
      // ignore save errors
    }
  }

  Future<void> _clearSessionCheckpoint() async {
    try {
      final storage = context.read<StorageService>();
      final sessionController = context.read<LearningSessionController>();
      await sessionController.clearCheckpoint(storage);
    } catch (_) {
      // ignore save errors
    }
  }

  void _updateSubIndex(int subIndex) {
    _currentSubIndex = subIndex;
    _persistSessionCheckpoint();
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionComplete) {
      return _SessionCompleteView(
        totalItems: _queue.length,
        onDone: () => Navigator.of(context).pop(),
      );
    }

    final currentItem = _queue[_currentIndex];
    final progress = (_currentIndex) / _queue.length;

    return Stack(
      children: [
        Semantics(
          container: true,
          label: 'Daily session. ${currentItem.type == DailyItemType.lesson ? 'Lesson' : 'Quiz'} ${_currentIndex + 1} of ${_queue.length}. ${currentItem.reason}.',
          hint: 'Complete the current item, then continue to the next session item.',
          child: Scaffold(
            backgroundColor: context.appColors.surfaceBase,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Semantics(
              button: true,
              label: 'Close session',
              hint: 'Leave the session and return to the study dashboard.',
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            title: Semantics(
              label: 'Session progress',
              value: '${_currentIndex + 1} of ${_queue.length}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: context.appColors.surfaceElevated,
                  valueColor: AlwaysStoppedAnimation<Color>(context.appColors.accentSuccess),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${_currentIndex + 1}/${_queue.length}',
                    style: context.textTheme.labelSmall?.copyWith(color: context.appColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
          body: currentItem.type == DailyItemType.lesson
                    ? _MicroLessonView(
                        lesson: currentItem.lesson!,
                        reason: currentItem.reason,
                        onComplete: _nextItem,
                        initialBlockIndex: _currentSubIndex,
                        onBlockChanged: _updateSubIndex,
                      )
                : _QuizSessionView(
                        quiz: currentItem.quiz!,
                        reason: currentItem.reason,
                        onComplete: _nextItem,
                        initialQuestionIndex: _currentSubIndex,
                        onQuestionChanged: _updateSubIndex,
                      ),
        ),
      ),
        for (final xp in _activeToasts)
          XpToast(
            xp: xp,
            onFinished: () {
              if (mounted) {
                setState(() {
                  _activeToasts.remove(xp);
                });
              }
            },
          ),
      ],
    );
  }
}

class _MicroLessonView extends StatefulWidget {
  const _MicroLessonView({required this.lesson, required this.reason, required this.onComplete, this.initialBlockIndex = 0, required this.onBlockChanged});

  final LessonUnit lesson;
  final String reason;
  final VoidCallback onComplete;
  final int initialBlockIndex;
  final Function(int) onBlockChanged;

  @override
  State<_MicroLessonView> createState() => _MicroLessonViewState();
}

class _MicroLessonViewState extends State<_MicroLessonView> {
  late int _blockIndex;
  bool _revealed = false;
  int _correctCount = 0;

  @override
  void initState() {
    super.initState();
    _blockIndex = widget.initialBlockIndex;
  }

  void _reveal() {
    setState(() {
      _revealed = true;
    });
  }

  void _recordRecall(bool recalled) {
    if (recalled) {
      _correctCount++;
    }
    // move to next block or finish
    if (_blockIndex < widget.lesson.blocks.length - 1) {
      setState(() {
        _blockIndex++;
        _revealed = false;
      });
      widget.onBlockChanged(_blockIndex);
      return;
    }
    // Finish lesson: derive quality from recall rate
    final ratio = widget.lesson.blocks.isEmpty ? 1.0 : (_correctCount / widget.lesson.blocks.length);
    int quality;
    if (ratio >= 0.85) {
      quality = 5;
    } else if (ratio >= 0.65) {
      quality = 4;
    } else if (ratio >= 0.4) {
      quality = 2;
    } else {
      quality = 1;
    }
    final store = context.read<ProgressController>();
    store.markLessonCompleted(widget.lesson.id, quality: quality);
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final block = widget.lesson.blocks[_blockIndex];
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudyCard(
                backgroundColor: context.appColors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.reason.toUpperCase(), style: textTheme.labelSmall?.copyWith(color: colors.accentWarning)),
                    const SizedBox(height: 8),
                    Text(widget.lesson.title, style: textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('${widget.lesson.durationMinutes} min · ${describeLearningFormat(widget.lesson.format)}', style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              StudyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_revealed) ...[
                      Text('Recall this concept', style: textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Text('Tap to reveal the content and self-test your recall.', style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _reveal,
                          child: const Text('Reveal'),
                        ),
                      ),
                    ] else ...[
                      _SessionBlockCard(block: block),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _recordRecall(false),
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                              child: const Text('Didn\'t recall'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => _recordRecall(true),
                              style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                              child: const Text('Recalled'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizSessionView extends StatefulWidget {
  const _QuizSessionView({
    required this.quiz,
    required this.reason,
    required this.onComplete,
    this.initialQuestionIndex = 0,
    required this.onQuestionChanged,
  });

  final QuizSet quiz;
  final String reason;
  final VoidCallback onComplete;
  final int initialQuestionIndex;
  final Function(int) onQuestionChanged;

  @override
  State<_QuizSessionView> createState() => _QuizSessionViewState();
}

class _QuizSessionViewState extends State<_QuizSessionView> {
  final Map<String, String> _selectedOptions = {};
  int _activeQuestionIndex = 0;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _activeQuestionIndex = widget.initialQuestionIndex;
  }

  int get _correctCount {
    var score = 0;
    for (final question in widget.quiz.questions) {
      final correct = question.correctOption;
      if (correct != null && _selectedOptions[question.id] == correct.label) {
        score++;
      }
    }
    return score;
  }

  void _onAnswer(String label) {
    setState(() {
      _selectedOptions[widget.quiz.questions[_activeQuestionIndex].id] = label;
      _showExplanation = true;
    });
  }

  void _onNext() {
    if (_activeQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _activeQuestionIndex++;
        _showExplanation = false;
      });
      widget.onQuestionChanged(_activeQuestionIndex);
    } else {
      setState(() {
        _activeQuestionIndex++; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final store = context.read<ProgressController>();

    if (_activeQuestionIndex >= widget.quiz.questions.length) {
      return _buildRatingView(context, store);
    }

    final question = widget.quiz.questions[_activeQuestionIndex];
    final selectedLabel = _selectedOptions[question.id];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              StudyCard(
                backgroundColor: colors.surfaceElevated,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reason.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(color: colors.accentWarning),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.quiz.title, style: textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      'Question ${_activeQuestionIndex + 1} of ${widget.quiz.questions.length}',
                      style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _SessionQuizQuestionCard(
                index: _activeQuestionIndex + 1,
                question: question,
                selectedLabel: selectedLabel,
                submitted: _showExplanation,
                onOptionSelected: _onAnswer,
              ),
              if (_showExplanation) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _onNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.accentPrimary,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(_activeQuestionIndex < widget.quiz.questions.length - 1 ? 'Next Question' : 'Finish Quiz'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingView(BuildContext context, ProgressController store) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: StudyCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quiz Complete!', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'You got $_correctCount out of ${widget.quiz.questions.length} correct',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              Text('How hard was this session?', style: textTheme.bodyMedium?.copyWith(color: colors.textSecondary)),
              const SizedBox(height: 16),
              _RatingStrip(
                onSelected: (quality) {
                  store.recordQuizAttempt(widget.quiz.id, _correctCount, widget.quiz.questions.length, quality: quality);
                  widget.onComplete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingStrip extends StatelessWidget {
  const _RatingStrip({required this.onSelected});
  final Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        _RatingButton(
          label: 'Again',
          subLabel: '<1m',
          color: colors.accentDanger,
          onTap: () => onSelected(1),
        ),
        const SizedBox(width: 8),
        _RatingButton(
          label: 'Hard',
          subLabel: '2d',
          color: colors.accentWarning,
          onTap: () => onSelected(2),
        ),
        const SizedBox(width: 8),
        _RatingButton(
          label: 'Good',
          subLabel: '4d',
          color: colors.accentSuccess,
          onTap: () => onSelected(4),
        ),
        const SizedBox(width: 8),
        _RatingButton(
          label: 'Easy',
          subLabel: '7d',
          color: colors.accentPrimary,
          onTap: () => onSelected(5),
        ),
      ],
    );
  }
}

class _RatingButton extends StatelessWidget {
  const _RatingButton({required this.label, required this.subLabel, required this.color, required this.onTap});
  final String label;
  final String subLabel;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            border: Border.all(color: color.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                subLabel,
                style: textTheme.labelSmall?.copyWith(color: color.withValues(alpha: 0.7), fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionBlockCard extends StatelessWidget {
  const _SessionBlockCard({required this.block});

  final LessonContentBlock block;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;

    switch (block.type) {
      case LessonBlockType.paragraph:
        return Text(block.content, style: textTheme.bodyLarge);
      case LessonBlockType.callout:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.accentPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.accentPrimary.withValues(alpha: 0.1)),
          ),
          child: Text(block.content, style: textTheme.bodyLarge),
        );
      case LessonBlockType.equation:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Math.tex(
            block.content,
            textStyle: textTheme.titleMedium,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.all(color: colors.borderSubtle, width: 0.5),
          children: rows.map((row) {
            final cells = row.split(',');
            final isHeader = row == rows.first;
            return TableRow(
              decoration: BoxDecoration(
                color: isHeader ? colors.surfaceElevated : null,
              ),
              children: cells.map((cell) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  cell.trim(),
                  style: isHeader 
                    ? textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: colors.textPrimary)
                    : textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
                ),
              )).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SessionQuizQuestionCard extends StatelessWidget {
  const _SessionQuizQuestionCard({
    required this.index,
    required this.question,
    required this.selectedLabel,
    required this.submitted,
    required this.onOptionSelected,
  });

  final int index;
  final QuizQuestion question;
  final String? selectedLabel;
  final bool submitted;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = context.appColors;
    final textTheme = context.textTheme;

    return StudyCard(
      backgroundColor: colors.surfaceCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final block in question.promptBlocks)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SessionBlockCard(block: block),
            ),
          const SizedBox(height: 12),
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: submitted ? null : () => onOptionSelected(option.label),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _optionColor(context, option, selectedLabel, submitted),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selectedLabel == option.label
                          ? colors.accentPrimary
                          : colors.borderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: selectedLabel == option.label ? colors.accentPrimary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedLabel == option.label ? colors.accentPrimary : colors.textMuted,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            option.label,
                            style: TextStyle(
                              color: selectedLabel == option.label ? Colors.white : colors.textMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option.value,
                          style: textTheme.bodyMedium?.copyWith(
                            color: selectedLabel == option.label ? colors.textPrimary : colors.textSecondary,
                            fontWeight: selectedLabel == option.label ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (submitted) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceBase,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Text(
                'Explanation: ${question.explanation}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
          AiExplanationArea(question: question),
        ],
      ),
    );
  }

  Color _optionColor(BuildContext context, QuestionOption option, String? selectedLabel, bool submitted) {
    final colors = context.appColors;
    if (!submitted) {
      return selectedLabel == option.label ? colors.accentPrimary.withValues(alpha: 0.1) : Colors.transparent;
    }
    final isCorrect = option.label == question.correctOption?.label;
    final isSelected = option.label == selectedLabel;

    if (isCorrect) return colors.accentSuccess.withValues(alpha: 0.2);
    if (isSelected && !isCorrect) return colors.accentDanger.withValues(alpha: 0.2);
    return Colors.transparent;
  }
}



class _SessionCompleteView extends StatelessWidget {
  const _SessionCompleteView({
    required this.totalItems,
    required this.onDone,
  });

  final int totalItems;
  final VoidCallback onDone;

  Future<void> _handleDone(BuildContext context) async {
    final notificationController = context.read<NotificationController>();
    if (notificationController.remindersEnabled) {
      await context.read<NotificationService>().requestPermissions();
    }
    onDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EmptyStateWidget(
        title: totalItems > 0 ? 'Session Complete!' : 'You\'re all caught up!',
        message: totalItems > 0 
          ? 'Great job! You\'ve completed $totalItems learning units for today. The spaced repetition engine has updated your review intervals.'
          : 'There are no items due for review right now. Take a break or explore other subjects!',
        imagePath: null, 
        actionLabel: 'Back to Home',
        onAction: () => _handleDone(context),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/catalog_repository.dart';
import '../../study/domain/learning_models.dart';
import '../../study/state/progress_controller.dart';

import '../../engagement/state/engagement_controller.dart';
import '../../engagement/presentation/xp_toast.dart';
import '../../ai/presentation/ai_explanation_area.dart';
import 'dart:async';

class QuizDetailScreen extends StatefulWidget {
  const QuizDetailScreen({super.key, required this.quizId});

  final String quizId;

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final Map<String, String> _selectedOptions = {};
  final Stopwatch _totalStopwatch = Stopwatch();
  bool _submitted = false;
  QuizSet? _quiz;
  final List<int> _activeToasts = [];
  StreamSubscription? _xpSubscription;

  @override
  void initState() {
    super.initState();
    final engagement = context.read<EngagementController>();
    _xpSubscription = engagement.xpEarnedStream.listen((xp) {
      if (mounted) {
        setState(() {
          _activeToasts.add(xp);
        });
      }
    });
  }

  @override
  void dispose() {
    _xpSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quiz ??= context.read<CatalogRepository>().getQuiz(widget.quizId);
  }

  int get _correctCount {
    if (_quiz == null) return 0;
    var score = 0;
    for (final question in _quiz!.questions) {
      final correct = question.correctOption;
      if (correct != null && _selectedOptions[question.id] == correct.label) {
        score++;
      }
    }
    return score;
  }

  bool get _canSubmit =>
      _quiz != null && _selectedOptions.length == _quiz!.questions.length && !_submitted;

  void _resetAttempt() {
    setState(() {
      _selectedOptions.clear();
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quiz == null) {
      return const Scaffold(body: Center(child: Text('Quiz not found')));
    }
    final theme = Theme.of(context);
    final progressStore = context.watch<ProgressController>();
    final savedAttempt = progressStore.quizAttemptFor(_quiz!.id);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text(_quiz!.title),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBF5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE6D9C3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _quiz!.title,
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_quiz!.questionCount} questions | ${describeExamFormat(_quiz!.examFormat)} | ${_quiz!.mode}',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 14),
                          if (_submitted)
                            Text(
                              'Score: $_correctCount / ${_quiz!.questions.length}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF0F766E),
                              ),
                            )
                          else if (savedAttempt != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latest saved score: ${savedAttempt.correctCount} / ${savedAttempt.totalQuestions}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF0F766E),
                                  ),
                                ),
                                if (savedAttempt.averageLatencyMs != null)
                                  Text(
                                    'Historical speed: ${(savedAttempt.averageLatencyMs! / 1000).toStringAsFixed(1)}s / question',
                                    style: theme.textTheme.bodySmall,
                                  ),
                              ],
                            )
                          else
                            Text(
                              'Answer each question and submit to reveal explanations.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          if (_submitted) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Average Speed: ${((_totalStopwatch.elapsedMilliseconds / _selectedOptions.length) / 1000).toStringAsFixed(1)}s / question',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (savedAttempt?.averageLatencyMs != null)
                              Builder(builder: (context) {
                                final current = _totalStopwatch.elapsedMilliseconds / _selectedOptions.length;
                                final historical = savedAttempt!.averageLatencyMs!;
                                final diff = ((current - historical) / historical) * 100;
                                final faster = diff < 0;
                                return Text(
                                  faster 
                                    ? '${diff.abs().toStringAsFixed(0)}% faster than your average' 
                                    : '${diff.toStringAsFixed(0)}% slower than your average',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: faster ? Colors.green : Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              }),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (var i = 0; i < _quiz!.questions.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _QuizQuestionCard(
                          index: i + 1,
                          question: _quiz!.questions[i],
                          selectedLabel:
                              _selectedOptions[_quiz!.questions[i].id],
                          submitted: _submitted,
                          onOptionSelected: (label) {
                            if (_submitted) return;
                            if (!_totalStopwatch.isRunning) {
                              _totalStopwatch.start();
                            }
                            setState(() {
                              _selectedOptions[_quiz!.questions[i].id] = label;
                            });
                          },
                        ),
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: _canSubmit
                              ? () {
                                  setState(() {
                                    _submitted = true;
                                  });
                                  _totalStopwatch.stop();
                                  final avgLatency = _selectedOptions.isEmpty 
                                    ? null 
                                    : (_totalStopwatch.elapsedMilliseconds / _selectedOptions.length).round();
                                  
                                  progressStore.recordQuizAttempt(
                                    _quiz!.id,
                                    _correctCount,
                                    _quiz!.questions.length,
                                    averageLatencyMs: avgLatency,
                                  );
                                }
                              : null,
                          child: const Text('Submit answers'),
                        ),
                        OutlinedButton(
                          onPressed: _selectedOptions.isEmpty && !_submitted
                              ? null
                              : _resetAttempt,
                          child: const Text('Reset attempt'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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

class _QuizQuestionCard extends StatelessWidget {
  const _QuizQuestionCard({
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

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question $index',
            style: theme.textTheme.titleMedium?.copyWith(
              color: const Color(0xFF0F766E),
            ),
          ),
          const SizedBox(height: 10),
          for (final block in question.promptBlocks)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuestionPromptBlock(block: block),
            ),
          const SizedBox(height: 4),
          for (final option in question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: submitted ? null : () => onOptionSelected(option.label),
                borderRadius: BorderRadius.circular(14),
                child: Semantics(
                  label: 'Option ${option.label}',
                  value: option.value,
                  selected: selectedLabel == option.label,
                  hint: submitted ? 'Correct answer is ${question.correctOption?.label}' : 'Tap to select',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _optionColor(option, selectedLabel, submitted),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selectedLabel == option.label
                            ? const Color(0xFF0F766E)
                            : const Color(0xFFE6D9C3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedLabel == option.label
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 20,
                          color: selectedLabel == option.label
                              ? const Color(0xFF0F766E)
                              : const Color(0xFF7A7A7A),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text('${option.label}. ${option.value}')),
                      ],
                    ),
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
                color: const Color(0xFFF3E7D3),
                borderRadius: BorderRadius.circular(16),
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

  Color _optionColor(QuestionOption option, String? selected, bool submitted) {
    if (!submitted) {
      return selected == option.label
          ? const Color(0xFFE8F3F1)
          : const Color(0xFFFFFBF5);
    }

    if (option.status == QuestionOptionStatus.correct) {
      return const Color(0xFFE8F3F1);
    }

    if (selected == option.label) {
      return const Color(0xFFFBE4E6);
    }

    return const Color(0xFFFFFBF5);
  }
}

class _QuestionPromptBlock extends StatelessWidget {
  const _QuestionPromptBlock({required this.block});

  final LessonContentBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (block.type) {
      case LessonBlockType.paragraph:
        return Text(block.content, style: theme.textTheme.bodyLarge);
      case LessonBlockType.callout:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(block.content, style: theme.textTheme.bodyLarge),
        );
      case LessonBlockType.equation:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6D9C3)),
          ),
          child: Math.tex(
            block.content,
            textStyle: theme.textTheme.titleMedium,
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
    final theme = Theme.of(context);
    final rows = content.split('|');
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Table(
          border: TableBorder.all(color: theme.dividerColor, width: 0.5),
          children: rows.map((row) {
            final cells = row.split(',');
            final isHeader = row == rows.first;
            return TableRow(
              decoration: BoxDecoration(
                color: isHeader ? theme.colorScheme.surfaceContainerHighest : null,
              ),
              children: cells.map((cell) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  cell.trim(),
                  style: isHeader 
                    ? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)
                    : theme.textTheme.bodyMedium,
                ),
              )).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}



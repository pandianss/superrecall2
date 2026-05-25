import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../study/domain/learning_models.dart';
import '../state/explanation_controller.dart';

class AiExplanationArea extends StatelessWidget {
  const AiExplanationArea({super.key, required this.question});
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final explanationCtrl = context.watch<ExplanationController>();
    final state = explanationCtrl.getState(question.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        if (!explanationCtrl.isAiAvailable)
          _TriggerButton(
            icon: Icons.auto_awesome_rounded,
            label: 'Explain with AI',
            onPressed: () => context.push('/settings'),
          )
        else if (state.status == ExplanationStatus.initial || state.status == ExplanationStatus.error)
          _TriggerButton(
            icon: Icons.auto_awesome_rounded,
            label: 'Explain with AI',
            onPressed: () {
              explanationCtrl.requestExplanation(
                itemId: question.id,
                question: question.promptBlocks.map((b) => b.content).join(' '),
                options: question.options.map((o) => '${o.label}. ${o.value}').toList(),
                correctAnswer: question.correctOption?.label ?? 'N/A',
              );
              _showExplanationSheet(context, question.id);
            },
          )
        else
          _TriggerButton(
            icon: Icons.auto_awesome_rounded,
            label: 'View AI Insight',
            onPressed: () => _showExplanationSheet(context, question.id),
          ),
      ],
    );
  }

  void _showExplanationSheet(BuildContext context, String questionId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AiExplanationSheet(questionId: questionId),
    );
  }
}

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({required this.icon, required this.label, required this.onPressed});
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: context.appColors.accentPrimary,
        backgroundColor: context.appColors.accentPrimary.withValues(alpha: 0.1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AiExplanationSheet extends StatelessWidget {
  const _AiExplanationSheet({required this.questionId});
  final String questionId;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final explanationCtrl = context.watch<ExplanationController>();
    final state = explanationCtrl.getState(questionId);

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.textMuted.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 20, color: colors.accentPrimary),
              const SizedBox(width: 10),
              Text(
                'AI TUTOR INSIGHTS',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.accentPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (state.status == ExplanationStatus.loading)
            _LoadingShimmer()
          else if (state.status == ExplanationStatus.success)
            MarkdownBody(
              data: state.content ?? '',
              styleSheet: MarkdownStyleSheet(
                p: textTheme.bodyMedium?.copyWith(height: 1.7),
                h1: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                h2: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                listBullet: textTheme.bodyMedium?.copyWith(color: colors.accentPrimary),
              ),
            )
          else if (state.status == ExplanationStatus.error)
            Text(
              'Could not load explanation: ${state.error}',
              style: textTheme.bodyMedium?.copyWith(color: colors.accentDanger),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 20, height: 20, decoration: const BoxDecoration(color: Color(0xFFE2E8F0), shape: BoxShape.circle)),
              const SizedBox(width: 12),
              Container(width: 120, height: 12, color: const Color(0xFFE2E8F0)),
            ],
          ),
          const SizedBox(height: 20),
          Container(width: double.infinity, height: 12, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Container(width: double.infinity, height: 12, color: const Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
          Container(width: 200, height: 12, color: const Color(0xFFF1F5F9)),
        ],
      ),
    );
  }
}

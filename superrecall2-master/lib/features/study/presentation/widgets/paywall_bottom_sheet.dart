import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/learning_models.dart';
import '../../state/progress_controller.dart';
import '../../../../core/theme/app_colors.dart';

class PaywallBottomSheet extends StatefulWidget {
  const PaywallBottomSheet({
    super.key,
    required this.subject,
    required this.module,
  });

  final SubjectCatalog subject;
  final ModuleCatalog module;

  static void show(BuildContext context, SubjectCatalog subject, ModuleCatalog module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaywallBottomSheet(subject: subject, module: module),
    );
  }

  @override
  State<PaywallBottomSheet> createState() => _PaywallBottomSheetState();
}

class _PaywallBottomSheetState extends State<PaywallBottomSheet> {
  int? _selectedTeaserOption;
  bool _showExplanation = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final progressStore = context.watch<ProgressController>();

    // Calculate metadata
    final totalLessons = widget.module.totalLessons;
    final estimatedTime = '${totalLessons * 15} minutes';
    
    String difficulty = 'Medium';
    String examRelevance = 'High (approx 12-15% of exam)';
    List<String> outcomes = [
      'Understand core principles and regulatory guidelines.',
      'Solve numerical case studies and practical banking questions.',
      'Boost memory retention using active recall & spaced repetition.'
    ];

    if (widget.subject.id == 'abm') {
      difficulty = 'Medium';
      examRelevance = 'High (25% of CAIIB exam)';
      outcomes = [
        'Apply statistics & measures of central tendency to banking datasets.',
        'Implement effective human resource development practices in banks.',
        'Master the management process, directive controls, and SWOT analyses.'
      ];
    } else if (widget.subject.id == 'bfm') {
      difficulty = 'Hard';
      examRelevance = 'Critical (28% of CAIIB exam)';
      outcomes = [
        'Calculate complex exchange rate arithmetic and cross/forward rates.',
        'Mitigate credit, market, and operational risks under Basel guidelines.',
        'Optimize bank balance sheet structures and manage liquidity gaps.'
      ];
    } else if (widget.subject.id == 'abfm') {
      difficulty = 'Hard';
      examRelevance = 'High (22% of CAIIB exam)';
      outcomes = [
        'Manage advanced capital budgeting, project appraisal, and corporate valuation.',
        'Analyze capital structures, leverage ratio impacts, and cost of capital.',
        'Develop corporate business strategies and financial controls.'
      ];
    } else if (widget.subject.id == 'brbl') {
      difficulty = 'Medium';
      examRelevance = 'High (25% of CAIIB exam)';
      outcomes = [
        'Interpret Banking Regulation Act and Reserve Bank of India directives.',
        'Ensure legally sound credit recovery, DRT, and SARFAESI compliance.',
        'Understand contracts, securities, and negotiable instruments law.'
      ];
    }

    // Teaser question based on subject
    String teaserQuestion = 'Which organization manages forex reserves in India?';
    List<String> teaserOptions = ['Finance Ministry', 'Reserve Bank of India (RBI)', 'State Bank of India', 'SEBI'];
    int correctAnswerIndex = 1;
    String explanation = 'The RBI is the sole custodian and manager of foreign exchange reserves in India.';

    if (widget.subject.id == 'abm') {
      teaserQuestion = 'What is the relation between Mean, Median, and Mode in a moderately skewed distribution?';
      teaserOptions = [
        'Mode = 3 Median - 2 Mean',
        'Mean = 3 Median - 2 Mode',
        'Median = 3 Mode - 2 Mean',
        'Mode = 2 Median - 3 Mean'
      ];
      correctAnswerIndex = 0;
      explanation = 'Karl Pearson\'s empirical formula states: Mode = 3 Median - 2 Mean.';
    } else if (widget.subject.id == 'bfm') {
      teaserQuestion = 'Under Basel III, what is the minimum Common Equity Tier 1 (CET1) capital requirement?';
      teaserOptions = ['3.5%', '4.5%', '5.5%', '6.0%'];
      correctAnswerIndex = 1;
      explanation = 'Basel III mandates a minimum CET1 ratio of 4.5% of risk-weighted assets.';
    } else if (widget.subject.id == 'abfm') {
      teaserQuestion = 'Which method considers time value of money when evaluating capital investments?';
      teaserOptions = ['Payback Period', 'Accounting Rate of Return', 'Net Present Value (NPV)', 'Simple Rate of Return'];
      correctAnswerIndex = 2;
      explanation = 'NPV discounts future cash flows, fully accounting for the time value of money.';
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: colors.borderSubtle, width: 1.5),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colors.textMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subject.name.toUpperCase(),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.accentPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.module.name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.lock_rounded, size: 28, color: colors.accentWarning),
            ],
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _MetaBadge(
                  icon: Icons.timer_outlined,
                  label: estimatedTime,
                ),
                const SizedBox(width: 8),
                _MetaBadge(
                  icon: Icons.offline_bolt_outlined,
                  label: difficulty,
                  color: difficulty == 'Hard' ? colors.accentDanger : colors.accentWarning,
                ),
                const SizedBox(width: 8),
                _MetaBadge(
                  icon: Icons.grade_outlined,
                  label: 'Relevance: $examRelevance',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'What you will master in this module:',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final outcome in outcomes)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded, color: colors.accentSuccess, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      outcome,
                      style: textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Text(
            'Teaser Exam Question:',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teaserQuestion, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                for (int i = 0; i < teaserOptions.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: _showExplanation
                          ? null
                          : () {
                              setState(() {
                                _selectedTeaserOption = i;
                                _showExplanation = true;
                              });
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTeaserOption == i
                              ? (i == correctAnswerIndex
                                  ? colors.accentSuccess.withValues(alpha: 0.15)
                                  : colors.accentDanger.withValues(alpha: 0.15))
                              : colors.surfaceCard,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedTeaserOption == i
                                ? (i == correctAnswerIndex ? colors.accentSuccess : colors.accentDanger)
                                : colors.borderSubtle,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + i)}. ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Text(teaserOptions[i])),
                            if (_selectedTeaserOption == i)
                              Icon(
                                i == correctAnswerIndex ? Icons.check_circle : Icons.cancel,
                                color: i == correctAnswerIndex ? colors.accentSuccess : colors.accentDanger,
                                size: 18,
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_showExplanation) ...[
                  const SizedBox(height: 12),
                  Text(
                    _selectedTeaserOption == correctAnswerIndex ? 'Correct!' : 'Incorrect.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedTeaserOption == correctAnswerIndex ? colors.accentSuccess : colors.accentDanger,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    explanation,
                    style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () {
                progressStore.purchaseSubject(widget.subject.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Successfully unlocked ${widget.subject.name}!'),
                    backgroundColor: colors.accentSuccess,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor: colors.accentPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Unlock All Chapters for \$${widget.subject.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Includes 35+ flashcards, formula cheat sheets, and 5 mock tests.',
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.icon,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = context.textTheme;
    final primaryColor = color ?? colors.accentPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: primaryColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

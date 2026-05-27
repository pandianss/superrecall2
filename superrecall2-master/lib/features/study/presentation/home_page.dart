import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/learning_models.dart';
import '../../engagement/presentation/settings_screen.dart';
import '../../../core/theme/app_colors.dart';

import 'study_tab.dart';
import 'curriculum_tab.dart';

class SuperRecallHomePage extends StatefulWidget {
  const SuperRecallHomePage({
    super.key,
    required this.exams,
    required this.selectedExam,
    required this.monthsToGoal,
    required this.onExamChanged,
    required this.onMonthsChanged,
    required this.onBuildPlan,
  });

  final List<ExamCatalog> exams;
  final ExamCatalog selectedExam;
  final double monthsToGoal;
  final ValueChanged<ExamCatalog> onExamChanged;
  final ValueChanged<double> onMonthsChanged;
  final VoidCallback onBuildPlan;

  @override
  State<SuperRecallHomePage> createState() => _SuperRecallHomePageState();
}

class _SuperRecallHomePageState extends State<SuperRecallHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return Scaffold(
      backgroundColor: colors.surfaceBase,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            StudyTab(selectedExam: widget.selectedExam),
            CurriculumTab(
              exams: widget.exams,
              selectedExam: widget.selectedExam,
              onExamChanged: widget.onExamChanged,
            ),
            const SettingsScreen(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0),
        child: SizedBox(
          width: 200,
          height: 56,
          child: FilledButton(
            onPressed: () {
              // Primary Continue action — navigates to the daily session for the selected exam.
              context.push('/daily-session/${widget.selectedExam.id}');
            },
            style: FilledButton.styleFrom(
              backgroundColor: colors.accentPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow_rounded),
                SizedBox(width: 8),
                Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: colors.surfaceCard,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickAction(
                  icon: Icons.today_rounded,
                  label: 'Today',
                  onTap: () => context.push('/daily-session/${widget.selectedExam.id}'),
                ),
                _QuickAction(
                  icon: Icons.replay_rounded,
                  label: 'Review',
                  onTap: () {
                    // Analytics/dashboard used as placeholder for review screen
                    context.push('/analytics/${widget.selectedExam.id}');
                  },
                ),
                _QuickAction(
                  icon: Icons.rule_rounded,
                  label: 'Mock',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mock/Test coming soon')));
                  },
                ),
                _QuickAction(
                  icon: Icons.warning_amber_rounded,
                  label: 'Weak',
                  onTap: () {
                    context.push('/drill/${widget.selectedExam.id}');
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.borderSubtle)),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: colors.surfaceCard,
              selectedItemColor: colors.accentPrimary,
              unselectedItemColor: colors.textMuted,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.bolt_rounded),
                  activeIcon: Icon(Icons.bolt_rounded),
                  label: 'Study',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_rounded),
                  activeIcon: Icon(Icons.menu_book_rounded),
                  label: 'Curriculum',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colors.accentPrimary),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: colors.textMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

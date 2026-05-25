import 'package:flutter/material.dart';

import '../domain/learning_models.dart';
import '../../engagement/presentation/analytics_dashboard_screen.dart';
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
            AnalyticsDashboardScreen(exam: widget.selectedExam),
            const SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics_rounded),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/empty_state_widget.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../state/learning_session_controller.dart';
import '../../engagement/state/engagement_controller.dart';
import 'daily_session_screen.dart';

class DrillSessionScreen extends StatelessWidget {
  const DrillSessionScreen({super.key, required this.examId});

  final String examId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<CatalogRepository>();
    final exam = repo.getExam(examId);
    if (exam == null) return const Scaffold(body: Center(child: Text('Exam not found')));

    final sessionController = context.read<LearningSessionController>();
    final queue = sessionController.getDailyQueue(exam, maxItems: 30).where((q) => q.isWeakArea).toList();

    if (queue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Drill Weak Areas')),
        body: Center(
          child: EmptyStateWidget(
            title: 'No weak items',
            message: 'You have no marked weak items for this exam right now.',
            actionLabel: 'Back',
            onAction: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Drill Weak Areas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Focused drill of ${queue.length} weak items', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text('Short, high-impact drills prioritized by forgetting rate.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => DailySessionScreen(examId: examId, initialQueue: queue)));
              },
              child: const Text('Start Drill'),
            ),
          ],
        ),
      ),
    );
  }
}

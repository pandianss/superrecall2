import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:superrecall/features/study/state/learning_session_controller.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import 'package:superrecall/features/study/state/progress_controller.dart';
import 'package:superrecall/features/engagement/state/engagement_controller.dart';
import 'package:superrecall/features/study/domain/learning_models.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  group('LearningSessionController', () {
    test('Identifies new and review items correctly', () async {
      final now = DateTime(2023, 1, 1);
      
      await withClock(Clock.fixed(now), () async {
        final storage = MockStorageService();
        final sync = MockSyncService();
        final srs = SrsController(storage, sync);
        final eng = EngagementController(storage, sync);
        final progress = ProgressController(storage, srs, eng, sync);
        final session = LearningSessionController(srs, progress);

        final exam = ExamCatalog(
          id: 'e1',
          name: 'Test Exam',
          shortDescription: '...',
          recommendedDailyMinutes: 30,
          weeklyAssessmentLabel: '...',
          weeklyRhythm: [],
          focusAreas: [],
          subjects: [
            SubjectCatalog(
              id: 's1',
              name: 'Subject 1',
              description: '...',
              examFormats: [],
              modules: [
                ModuleCatalog(
                  id: 'm1',
                  name: 'Module 1',
                  description: '...',
                  topics: [
                    TopicCatalog(
                      id: 't1',
                      name: 'Topic 1',
                      summary: '...',
                      examFormats: [],
                      notationSupport: false,
                      lessons: [
                        const LessonUnit(id: 'l1', title: 'L1', durationMinutes: 5, format: LearningFormat.note, blocks: []),
                        const LessonUnit(id: 'l2', title: 'L2', durationMinutes: 5, format: LearningFormat.note, blocks: []),
                      ],
                      quizzes: [],
                      progress: const TopicProgress(completedLessons: 0, masteryPercent: 0),
                    )
                  ],
                )
              ],
            )
          ],
        );

        // Schedule l1 to be due tomorrow (interval 1) via markLessonCompleted
        progress.markLessonCompleted('l1', quality: 4);

        // Move time forward by 2 days to ensure l1 is overdue
        await withClock(Clock.fixed(now.add(const Duration(days: 2))), () async {
          final items = session.getDailyQueue(exam);
          
          // Should have 1 review (l1) and 1 new (l2)
          expect(items.where((i) => i.overdueAmount != null).length, 1);
          expect(items.where((i) => i.overdueAmount == null).length, 1);
          expect(items.any((i) => i.lesson?.id == 'l1'), isTrue);
          expect(items.any((i) => i.lesson?.id == 'l2'), isTrue);
        });
      });
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:superrecall/features/study/state/learning_session_controller.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import 'package:superrecall/data/local/storage_service.dart';
import 'package:superrecall/data/repositories/catalog_repository.dart';
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

    test('Checkpoint payload stores queue state and can be restored', () async {
      final storage = _RecordingStorageService();
      final sync = MockSyncService();
      final srs = SrsController(storage, sync);
      final eng = EngagementController(storage, sync);
      final progress = ProgressController(storage, srs, eng, sync);
      final session = LearningSessionController(srs, progress);

      final lesson = const LessonUnit(
        id: 'l1',
        title: 'Saved Lesson',
        durationMinutes: 3,
        format: LearningFormat.note,
        blocks: [],
      );
      final quiz = const QuizSet(
        id: 'q1',
        title: 'Saved Quiz',
        questionCount: 1,
        mode: 'practice',
        examFormat: ExamFormatType.mcq,
        questions: [],
      );
      final queue = [
        DailyQueueItem(
          id: lesson.id,
          type: DailyItemType.lesson,
          isWeakArea: false,
          sequenceIndex: 1,
          lesson: lesson,
        ),
        DailyQueueItem(
          id: quiz.id,
          type: DailyItemType.quiz,
          isWeakArea: true,
          sequenceIndex: 2,
          quiz: quiz,
        ),
      ];

      await session.saveCheckpoint(storage, 'exam1', queue, 1, 0);
      expect(storage.savedPayload, isNotNull);
      final payload = storage.savedPayload!;

      expect(payload['examId'], 'exam1');
      expect(payload['currentIndex'], 1);
      expect(payload['subIndex'], 0);
      expect(payload['queueJson'], isA<String>());

      final restoredRepo = _TestCatalogRepository(lessons: {lesson.id: lesson}, quizzes: {quiz.id: quiz});
      final restoredQueue = session.restoreQueueFromCheckpoint(payload, restoredRepo);

      expect(restoredQueue, hasLength(2));
      expect(restoredQueue[0].lesson?.id, lesson.id);
      expect(restoredQueue[1].quiz?.id, quiz.id);
      expect(restoredQueue[1].isWeakArea, isTrue);
    });
  });
}

class _RecordingStorageService extends StorageService {
  Map<String, dynamic>? savedPayload;

  @override
  Future<void> saveSessionCheckpoint(Map<String, dynamic> data) async {
    savedPayload = data;
  }
}

class _TestCatalogRepository extends CatalogRepository {
  final Map<String, LessonUnit> lessons;
  final Map<String, QuizSet> quizzes;

  _TestCatalogRepository({required this.lessons, required this.quizzes});

  @override
  LessonUnit? getLesson(String lessonId) => lessons[lessonId];

  @override
  QuizSet? getQuiz(String quizId) => quizzes[quizId];
}

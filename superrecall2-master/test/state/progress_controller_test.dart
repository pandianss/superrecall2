import 'package:flutter_test/flutter_test.dart';
import 'package:superrecall/features/study/state/progress_controller.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import 'package:superrecall/features/engagement/state/engagement_controller.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  test('ProgressController tracks completed lessons and saves state', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final srs = SrsController(storage, sync);
    final eng = EngagementController(storage, sync);
    final progress = ProgressController(storage, srs, eng, sync);
    
    await progress.init();
    
    progress.markLessonCompleted('lesson_1', quality: 4);
    
    expect(progress.isLessonCompleted('lesson_1'), isTrue);
    expect(storage.progress, isNotNull);
    expect((storage.progress!['completedLessons'] as List).contains('lesson_1'), isTrue);
  });

  test('ProgressController tracks quiz attempts', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final srs = SrsController(storage, sync);
    final eng = EngagementController(storage, sync);
    final progress = ProgressController(storage, srs, eng, sync);
    
    await progress.init();
    
    progress.recordQuizAttempt('quiz_1', 8, 10);
    
    final attempt = progress.quizAttemptFor('quiz_1');
    expect(attempt, isNotNull);
    expect(attempt!.correctCount, 8);
    expect(attempt.percent, 80);
    
    expect(storage.progress!['quizAttempts'], isNotNull);
    expect(storage.progress!['quizAttempts']['quiz_1'], isNotNull);
  });
}

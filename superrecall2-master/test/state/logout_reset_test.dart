import 'package:flutter_test/flutter_test.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import 'package:superrecall/features/study/state/progress_controller.dart';
import 'package:superrecall/features/engagement/state/engagement_controller.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  group('Auth logout resets state controllers in memory', () {
    test('SrsController, ProgressController, and EngagementController reset correctly', () async {
      final storage = MockStorageService();
      final sync = MockSyncService();

      final srs = SrsController(storage, sync);
      final engagement = EngagementController(storage, sync);
      final progress = ProgressController(storage, srs, engagement, sync);

      await srs.init();
      await engagement.init();
      await progress.init();

      // Set some dummy dirty states
      srs.scheduleReview('item_test', 4);
      progress.markLessonCompleted('lesson_test', quality: 5);
      engagement.recordActivity(100);

      // Verify states are set
      expect(srs.getInterval('item_test'), isNotNull);
      expect(progress.isLessonCompleted('lesson_test'), isTrue);
      expect(engagement.metrics.totalXp, isPositive);

      // Act: emit logout
      sync.emitLogout();

      // Wait a microtask for stream listeners to trigger
      await Future.delayed(Duration.zero);

      // Assert: Verify states are cleared in memory
      expect(srs.getInterval('item_test'), isNull);
      expect(progress.isLessonCompleted('lesson_test'), isFalse);
      expect(engagement.metrics.totalXp, equals(0));
      expect(engagement.metrics.currentStreak, equals(0));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  group('SrsController Edge Cases', () {
    test('quality < 3 resets repetitions and sets interval to 1 day', () async {
      final storage = MockStorageService();
      final sync = MockSyncService();
      final srs = SrsController(storage, sync);
      await srs.init();

      final baseTime = DateTime(2023, 1, 1);
      
      // Setup: Item with 5 repetitions
      withClock(Clock.fixed(baseTime), () {
        for (int i = 0; i < 5; i++) {
          srs.scheduleReview('item1', 4);
        }
      });

      final beforeLapse = srs.getInterval('item1')!;
      expect(beforeLapse.repetitions, 5);

      // Act: Fail the review (quality 2)
      withClock(Clock.fixed(baseTime.add(const Duration(days: 100))), () {
        srs.scheduleReview('item1', 2);
      });

      // Assert
      final afterLapse = srs.getInterval('item1')!;
      expect(afterLapse.repetitions, 0, reason: 'Repetitions should reset on failure');
      expect(afterLapse.intervalDays, 1, reason: 'Interval should reset to 1 day on failure');
    });

    test('ease factor never drops below 1.3', () async {
      final storage = MockStorageService();
      final sync = MockSyncService();
      final srs = SrsController(storage, sync);
      await srs.init();

      final baseTime = DateTime(2023, 1, 1);
      
      // Repeated failures
      withClock(Clock.fixed(baseTime), () {
        for (int i = 0; i < 10; i++) {
          srs.scheduleReview('item1', 0); // Lowest quality
        }
      });

      final interval = srs.getInterval('item1')!;
      expect(interval.easeFactor, 1.3, reason: 'Ease factor should be clamped at 1.3');
    });

    test('ease factor never exceeds 3.0', () async {
      final storage = MockStorageService();
      final sync = MockSyncService();
      final srs = SrsController(storage, sync);
      await srs.init();

      final baseTime = DateTime(2023, 1, 1);
      
      // Repeated successes
      withClock(Clock.fixed(baseTime), () {
        for (int i = 0; i < 30; i++) { // More iterations to reach 3.0
          srs.scheduleReview('item1', 5); // Highest quality
        }
      });

      final interval = srs.getInterval('item1')!;
      expect(interval.easeFactor, 3.0, reason: 'Ease factor should be clamped at 3.0');
    });
  });
}

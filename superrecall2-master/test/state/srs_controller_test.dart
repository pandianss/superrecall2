import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:superrecall/features/study/state/srs_controller.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  test('SrsController schedules initial interval correctly based on quality', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final srs = SrsController(storage, sync);
    await srs.init();

    final baseTime = DateTime(2023, 1, 1);
    
    withClock(Clock.fixed(baseTime), () {
      srs.scheduleReview('l1', 4); // Solid recall -> interval 1
    });

    final interval = srs.getInterval('l1');
    expect(interval, isNotNull);
    expect(interval!.intervalDays, 1);
    expect(interval.easeFactor, 2.5);
    expect(interval.nextReviewDate, baseTime.add(const Duration(days: 1)));
  });

  test('SrsController increases interval on repeated correct answers', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final srs = SrsController(storage, sync);
    await srs.init();

    final baseTime = DateTime(2023, 1, 1);
    
    withClock(Clock.fixed(baseTime), () {
      srs.scheduleReview('item1', 4); // First review -> 1 day
    });

    withClock(Clock.fixed(baseTime.add(const Duration(days: 1))), () {
      srs.scheduleReview('item1', 4); // Second review -> 6 days
    });

    final interval = srs.getInterval('item1');
    expect(interval, isNotNull);
    expect(interval!.intervalDays, 6);
    // Ease factor remains 2.5 for quality 4
    expect(interval.easeFactor, 2.5);
    expect(interval.nextReviewDate, baseTime.add(const Duration(days: 7)));
  });

  test('SrsController updateInterval maps confidence levels correctly', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final srs = SrsController(storage, sync);
    await srs.init();

    final baseTime = DateTime(2023, 1, 1);

    withClock(Clock.fixed(baseTime), () {
      srs.updateInterval('item_easy', 'easy');     // maps to quality 5 -> interval 1, ease 2.5
      srs.updateInterval('item_medium', 'medium'); // maps to quality 3 -> interval 1, ease 2.5
      srs.updateInterval('item_hard', 'hard');     // maps to quality 1 -> interval 1 (existing null resets repetitions/interval to 0 or 1 depending on SM-2 implementation)
    });

    final intervalEasy = srs.getInterval('item_easy');
    expect(intervalEasy, isNotNull);
    expect(intervalEasy!.intervalDays, 1);

    final intervalMedium = srs.getInterval('item_medium');
    expect(intervalMedium, isNotNull);
    expect(intervalMedium!.intervalDays, 1);
  });
}

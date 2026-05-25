import 'package:flutter_test/flutter_test.dart';
import 'package:clock/clock.dart';
import 'package:superrecall/features/engagement/state/engagement_controller.dart';
import '../mock_storage_service.dart';
import '../mock_sync_service.dart';

void main() {
  test('EngagementController tracks streaks and XP', () async {
    final storage = MockStorageService();
    final sync = MockSyncService();
    final ctrl = EngagementController(storage, sync);
    await ctrl.init();

    final day1 = DateTime(2023, 1, 1);
    
    // Day 1: First activity
    withClock(Clock.fixed(day1), () {
      ctrl.recordActivity(100);
      expect(ctrl.metrics.totalXp, 100);
      expect(ctrl.metrics.currentStreak, 1);
    });

    // Day 2: Consecutive activity
    withClock(Clock.fixed(day1.add(const Duration(days: 1))), () {
      ctrl.recordActivity(100);
      // XP: 100 base + 10 streak bonus = 110. Total 210.
      expect(ctrl.metrics.totalXp, 210);
      expect(ctrl.metrics.currentStreak, 2);
    });

    // Day 4: Break in streak (skipped Day 3)
    withClock(Clock.fixed(day1.add(const Duration(days: 3))), () {
      ctrl.recordActivity(100);
      // XP: 210 + 100 (streak bonus 0) = 310
      expect(ctrl.metrics.totalXp, 310);
      expect(ctrl.metrics.currentStreak, 1);
    });
  });
}

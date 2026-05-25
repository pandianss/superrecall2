import 'package:flutter_test/flutter_test.dart';
import 'package:superrecall/data/remote/sync_service.dart';
import '../mock_storage_service.dart';
import '../mock_firebase.dart';

void main() {
  group('SyncService Merge Logic', () {
    late SyncService syncService;

    setUp(() {
      syncService = SyncService(
        MockStorageService(),
        auth: MockFirebaseAuth(),
        firestore: MockFirebaseFirestore(),
      );
    });

    test('mergeData unions completed lessons (local wins on conflicts)', () {
      final local = {
        'progress': {
          'completedLessons': {'lesson1': '2023-01-01T10:00:00Z', 'lesson2': '2023-01-01T11:00:00Z'},
        }
      };
      final remote = {
        'progress': {
          'completedLessons': {'lesson2': '2023-01-01T09:00:00Z', 'lesson3': '2023-01-01T12:00:00Z'},
        }
      };

      final result = syncService.mergeData(local, remote);
      final lessons = result['progress']['completedLessons'];

      expect(lessons.length, 3);
      expect(lessons['lesson1'], '2023-01-01T10:00:00Z');
      expect(lessons['lesson2'], '2023-01-01T11:00:00Z', reason: 'Local timestamp should win');
      expect(lessons['lesson3'], '2023-01-01T12:00:00Z');
    });

    test('mergeData unions quiz attempts', () {
      final local = {
        'progress': {
          'quizAttempts': {'quiz1': {'correctCount': 5}},
        }
      };
      final remote = {
        'progress': {
          'quizAttempts': {'quiz2': {'correctCount': 3}},
        }
      };

      final result = syncService.mergeData(local, remote);
      final quizzes = result['progress']['quizAttempts'];

      expect(quizzes.containsKey('quiz1'), true);
      expect(quizzes.containsKey('quiz2'), true);
    });

    test('mergeData uses local wins for monthsToGoal', () {
      final local = {
        'progress': {'monthsToGoal': 3}
      };
      final remote = {
        'progress': {'monthsToGoal': 12}
      };

      final result = syncService.mergeData(local, remote);
      expect(result['progress']['monthsToGoal'], 3);
    });

    test('mergeData takes max XP and streak for engagement', () {
      final local = {
        'engagement': {'totalXp': 1000, 'currentStreak': 5}
      };
      final remote = {
        'engagement': {'totalXp': 1500, 'currentStreak': 2}
      };

      final result = syncService.mergeData(local, remote);
      expect(result['engagement']['totalXp'], 1500);
      expect(result['engagement']['currentStreak'], 5);
    });
  });
}

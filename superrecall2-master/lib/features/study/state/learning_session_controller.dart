import 'package:flutter/foundation.dart';
import 'package:clock/clock.dart';
import '../domain/learning_models.dart';
import 'srs_controller.dart';
import 'progress_controller.dart';
import 'dart:convert';
import '../../../data/local/storage_service.dart';
import '../../../data/repositories/catalog_repository.dart';

enum DailyItemType { lesson, quiz }

class DailyQueueItem {
  const DailyQueueItem({
    required this.id,
    required this.type,
    required this.isWeakArea,
    this.overdueAmount,
    this.sequenceIndex = 0,
    this.lesson,
    this.quiz,
  });

  final String id;
  final DailyItemType type;
  final bool isWeakArea;
  final Duration? overdueAmount;
  final int sequenceIndex;
  final LessonUnit? lesson;
  final QuizSet? quiz;

  String get reason {
    if (isWeakArea) return 'Targeting a weak area';
    if (overdueAmount != null) {
      if (overdueAmount!.inDays > 0) {
        return 'Review overdue by ${overdueAmount!.inDays} days';
      }
      return 'Scheduled for review today';
    }
    return 'New curriculum item';
  }
}

class LearningSessionController extends ChangeNotifier {
  final SrsController _srsController;
  final ProgressController _progressController;

  List<DailyQueueItem>? _cachedQueue;
  String? _cachedQueueExamId;
  int? _cachedCompletedCount;
  String? _cachedCompletedExamId;

  LearningSessionController(this._srsController, this._progressController) {
    _srsController.addListener(_onDependencyChanged);
    _progressController.addListener(_onDependencyChanged);
  }

  @override
  void dispose() {
    _srsController.removeListener(_onDependencyChanged);
    _progressController.removeListener(_onDependencyChanged);
    super.dispose();
  }

  void _onDependencyChanged() {
    _cachedQueue = null;
    _cachedCompletedCount = null;
    notifyListeners();
  }

  List<DailyQueueItem> getDailyQueue(ExamCatalog exam, {int maxItems = 5}) {
    if (_cachedQueue != null && _cachedQueueExamId == exam.id) {
      return _cachedQueue!;
    }
    _cachedQueueExamId = exam.id;
    _cachedQueue = _computeDailyQueue(exam, maxItems: maxItems);
    return _cachedQueue!;
  }

  List<DailyQueueItem> _computeDailyQueue(ExamCatalog exam, {int maxItems = 5}) {
    final now = clock.now();
    final weakTopics = _progressController.getWeakTopics(exam).map((t) => t.id).toSet();

    final dueReviews = <DailyQueueItem>[];
    final newItems = <DailyQueueItem>[];

    int sequenceCounter = 0;

    for (final subject in exam.subjects) {
      if (subject.isPremium && !_progressController.isSubjectPurchased(subject.id)) {
        continue;
      }
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          final isWeak = weakTopics.contains(topic.id);

          for (final lesson in topic.lessons) {
            sequenceCounter++;
            final interval = _srsController.getInterval(lesson.id);
            if (interval != null) {
              if (interval.nextReviewDate.isBefore(now)) {
                dueReviews.add(DailyQueueItem(
                  id: lesson.id,
                  type: DailyItemType.lesson,
                  isWeakArea: isWeak,
                  overdueAmount: now.difference(interval.nextReviewDate),
                  lesson: lesson,
                ));
              }
            } else if (!_progressController.isLessonCompleted(lesson.id)) {
              newItems.add(DailyQueueItem(
                id: lesson.id,
                type: DailyItemType.lesson,
                isWeakArea: isWeak,
                sequenceIndex: sequenceCounter,
                lesson: lesson,
              ));
            }
          }

          for (final quiz in topic.quizzes) {
            sequenceCounter++;
            final interval = _srsController.getInterval(quiz.id);
            if (interval != null) {
              if (interval.nextReviewDate.isBefore(now)) {
                dueReviews.add(DailyQueueItem(
                  id: quiz.id,
                  type: DailyItemType.quiz,
                  isWeakArea: isWeak,
                  overdueAmount: now.difference(interval.nextReviewDate),
                  quiz: quiz,
                ));
              }
            } else if (_progressController.quizAttemptFor(quiz.id) == null) {
              newItems.add(DailyQueueItem(
                id: quiz.id,
                type: DailyItemType.quiz,
                isWeakArea: isWeak,
                sequenceIndex: sequenceCounter,
                quiz: quiz,
              ));
            }
          }
        }
      }
    }

    // Sort due reviews: Weak areas first, then by how overdue they are
    dueReviews.sort((a, b) {
      if (a.isWeakArea && !b.isWeakArea) return -1;
      if (!a.isWeakArea && b.isWeakArea) return 1;

      // Prefer items with lower recall strength (weaker memory) first
      final aInterval = _srsController.getInterval(a.id);
      final bInterval = _srsController.getInterval(b.id);
      final aStrength = aInterval?.recallStrength ?? 0.5;
      final bStrength = bInterval?.recallStrength ?? 0.5;
      if (aStrength != bStrength) return aStrength.compareTo(bStrength);

      final aOverdue = a.overdueAmount ?? Duration.zero;
      final bOverdue = b.overdueAmount ?? Duration.zero;
      return bOverdue.compareTo(aOverdue); // larger overdue amount first
    });

    // Sort new items: Weak areas first, then by curriculum sequence
    newItems.sort((a, b) {
      if (a.isWeakArea && !b.isWeakArea) return -1;
      if (!a.isWeakArea && b.isWeakArea) return 1;

      // For new items, prefer lower sequenceIndex (curriculum order)
      return a.sequenceIndex.compareTo(b.sequenceIndex);
    });

    final queue = <DailyQueueItem>[];
    queue.addAll(dueReviews.take(maxItems));
    
    if (queue.length < maxItems) {
      queue.addAll(newItems.take(maxItems - queue.length));
    }

    return queue;
  }

  int getCompletedCountToday(ExamCatalog exam) {
    if (_cachedCompletedCount != null && _cachedCompletedExamId == exam.id) {
      return _cachedCompletedCount!;
    }
    _cachedCompletedExamId = exam.id;
    _cachedCompletedCount = _computeCompletedCountToday(exam);
    return _cachedCompletedCount!;
  }

  int _computeCompletedCountToday(ExamCatalog exam) {
    final now = clock.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    var count = 0;

    for (final subject in exam.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          for (final lesson in topic.lessons) {
            final interval = _srsController.getInterval(lesson.id);
            if (interval?.lastReviewedDate != null && 
                interval!.lastReviewedDate!.isAfter(todayStart)) {
              count++;
            }
          }
          for (final quiz in topic.quizzes) {
            final interval = _srsController.getInterval(quiz.id);
            if (interval?.lastReviewedDate != null && 
                interval!.lastReviewedDate!.isAfter(todayStart)) {
              count++;
            }
          }
        }
      }
    }
    return count;
  }

  // --- Checkpoint helpers ---
  Map<String, dynamic> makeCheckpointPayload(String examId, List<DailyQueueItem> queue, int currentIndex, int? subIndex) {
    final queueMinimal = queue.map((e) => {
      'id': e.id,
      'type': e.type == DailyItemType.lesson ? 'lesson' : 'quiz',
      'isWeakArea': e.isWeakArea,
      'sequenceIndex': e.sequenceIndex,
    }).toList();

    return {
      'examId': examId,
      'currentIndex': currentIndex,
      'subIndex': subIndex,
      'savedAt': DateTime.now().toIso8601String(),
      'queueJson': json.encode(queueMinimal),
    };
  }

  Future<void> saveCheckpoint(StorageService storage, String examId, List<DailyQueueItem> queue, int currentIndex, int? subIndex) async {
    if (storage == null) return;
    final payload = makeCheckpointPayload(examId, queue, currentIndex, subIndex);
    await storage.saveSessionCheckpoint(payload);
  }

  Future<void> clearCheckpoint(StorageService storage) async {
    if (storage == null) return;
    await storage.clearSessionCheckpoint();
  }

  List<DailyQueueItem> restoreQueueFromCheckpoint(Map<String, dynamic> chk, CatalogRepository repo) {
    final qJson = chk['queueJson'] as String?;
    if (qJson == null || qJson.isEmpty) return [];
    try {
      final parsed = json.decode(qJson) as List<dynamic>;
      final restored = <DailyQueueItem>[];
      for (final item in parsed) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] as String;
        final type = map['type'] as String;
        final isWeak = map['isWeakArea'] as bool? ?? false;
        final seq = map['sequenceIndex'] as int? ?? 0;

        if (type == 'lesson') {
          final lesson = repo.getLesson(id);
          if (lesson != null) {
            restored.add(DailyQueueItem(
              id: id,
              type: DailyItemType.lesson,
              isWeakArea: isWeak,
              sequenceIndex: seq,
              lesson: lesson,
            ));
          }
        } else {
          final quiz = repo.getQuiz(id);
          if (quiz != null) {
            restored.add(DailyQueueItem(
              id: id,
              type: DailyItemType.quiz,
              isWeakArea: isWeak,
              sequenceIndex: seq,
              quiz: quiz,
            ));
          }
        }
      }
      return restored;
    } catch (e) {
      return [];
    }
  }
}

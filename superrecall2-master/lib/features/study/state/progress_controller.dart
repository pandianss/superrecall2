import 'package:flutter/widgets.dart';
import '../../../data/local/storage_service.dart';
import '../domain/learning_models.dart';
import 'srs_controller.dart';
import '../../engagement/state/engagement_controller.dart';
import '../../../data/remote/sync_service.dart';

class QuizAttemptResult {
  const QuizAttemptResult({
    required this.correctCount,
    required this.totalQuestions,
    this.averageLatencyMs,
  });

  final int correctCount;
  final int totalQuestions;
  final int? averageLatencyMs;

  int get percent =>
      totalQuestions == 0 ? 0 : ((correctCount / totalQuestions) * 100).round();

  Map<String, dynamic> toJson() => {
        'correctCount': correctCount,
        'totalQuestions': totalQuestions,
        'averageLatencyMs': averageLatencyMs,
      };

  factory QuizAttemptResult.fromJson(Map<String, dynamic> json) =>
      QuizAttemptResult(
        correctCount: json['correctCount'] as int,
        totalQuestions: json['totalQuestions'] as int,
        averageLatencyMs: json['averageLatencyMs'] as int?,
      );
}

class ProgressController extends ChangeNotifier {
  final StorageService _storage;
  final SrsController _srsController;
  final EngagementController _engagementController;
  final SyncService _syncService;

  ProgressController(this._storage, this._srsController, this._engagementController, this._syncService) {
    _syncService.authEvents.listen((event) {
      if (event == AuthEvent.logout) {
        _clearInMemory();
      }
    });
  }

  void _clearInMemory() {
    _completedLessonIds.clear();
    _purchasedSubjectIds.clear();
    _quizAttemptsById.clear();
    _baselineCompletedLessons.clear();
    _baselineMasteryByTopicId.clear();
    notifyListeners();
  }

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  int _monthsToGoal = 6;
  int get monthsToGoal => _monthsToGoal;

  final Set<String> _completedLessonIds = {};
  final Set<String> _purchasedSubjectIds = {};
  final Map<String, QuizAttemptResult> _quizAttemptsById = {};
  final Map<String, int> _baselineCompletedLessons = {};
  final Map<String, int> _baselineMasteryByTopicId = {};

  Future<void> init() async {
    final saved = await _storage.getProgress();
    if (saved != null) {
      if (saved['completedLessons'] != null) {
        _completedLessonIds.addAll((saved['completedLessons'] as Map).keys.cast<String>());
      }
      if (saved['quizAttempts'] != null) {
        (saved['quizAttempts'] as Map).forEach((key, value) {
          _quizAttemptsById[key] = QuizAttemptResult.fromJson(Map<String, dynamic>.from(value));
        });
      }
      _monthsToGoal = saved['monthsToGoal'] ?? 6;
    }
    
    final purchases = await _storage.getPurchasedSubjects();
    _purchasedSubjectIds.addAll(purchases);

    _isLoaded = true;
    notifyListeners();
  }

  bool isSubjectPurchased(String subjectId) => _purchasedSubjectIds.contains(subjectId);

  Future<void> purchaseSubject(String subjectId) async {
    _purchasedSubjectIds.add(subjectId);
    await _storage.saveSubjectPurchase(subjectId);
    notifyListeners();
  }

  void _save() {
    _storage.saveProgress({
      'completedLessons': _completedLessonIds.toList(),
      'quizAttempts': _quizAttemptsById.map((k, v) => MapEntry(k, v.toJson())),
      'monthsToGoal': _monthsToGoal,
    });
    _syncService.pushLocalProgress();
  }

  Future<void> setMonthsToGoal(int months) async {
    _monthsToGoal = months;
    _save();
    notifyListeners();
  }

  Future<void> seedBaselines(List<ExamCatalog> exams) async {
    if (_completedLessonIds.isNotEmpty) return;

    for (final exam in exams) {
      for (final subject in exam.subjects) {
        for (final module in subject.modules) {
          for (final topic in module.topics) {
            _baselineCompletedLessons[topic.id] = topic.progress.completedLessons;
            _baselineMasteryByTopicId[topic.id] = topic.progress.masteryPercent;
            for (var i = 0; i < topic.progress.completedLessons; i++) {
              if (i < topic.lessons.length) {
                _completedLessonIds.add(topic.lessons[i].id);
              }
            }
          }
        }
      }
    }
    _save();
  }

  bool isLessonCompleted(String lessonId) =>
      _completedLessonIds.contains(lessonId);

  QuizAttemptResult? quizAttemptFor(String quizId) => _quizAttemptsById[quizId];

  void markLessonCompleted(String lessonId, {int quality = 4}) {
    _completedLessonIds.add(lessonId);
    _srsController.scheduleReview(lessonId, quality);
    _engagementController.recordActivity(50 + (quality >= 5 ? 20 : 0));
    _save();
    notifyListeners();
  }

  int _scoreToQuality(int correctCount, int totalQuestions) {
    if (totalQuestions == 0) return 0;
    final ratio = correctCount / totalQuestions;
    if (ratio >= 0.95) return 5;
    if (ratio >= 0.80) return 4;
    if (ratio >= 0.60) return 3;
    if (ratio >= 0.40) return 2;
    if (ratio >= 0.20) return 1;
    return 0;
  }

  void recordQuizAttempt(String quizId, int correctCount, int totalQuestions, {int? quality, int? averageLatencyMs}) {
    _quizAttemptsById[quizId] = QuizAttemptResult(
      correctCount: correctCount,
      totalQuestions: totalQuestions,
      averageLatencyMs: averageLatencyMs,
    );
    
    final finalQuality = quality ?? _scoreToQuality(correctCount, totalQuestions);
    _srsController.scheduleReview(quizId, finalQuality);
    
    // XP: 100 base + perfect score bonus
    int xp = 100;
    if (correctCount == totalQuestions && totalQuestions > 0) xp += 50;
    _engagementController.recordActivity(xp);
    _save();
    notifyListeners();
  }

  int completedLessonsForExam(ExamCatalog exam) {
    var completed = 0;
    for (final subject in exam.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          completed += progressForTopic(topic).completedLessons;
        }
      }
    }
    return completed;
  }

  int attemptedQuizzesForExam(ExamCatalog exam) {
    var count = 0;
    for (final subject in exam.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          for (final quiz in topic.quizzes) {
            if (_quizAttemptsById.containsKey(quiz.id)) {
              count++;
            }
          }
        }
      }
    }
    return count;
  }

  TopicProgress progressForTopic(TopicCatalog topic) {
    final completedLessons = topic.lessons
        .where((lesson) => _completedLessonIds.contains(lesson.id))
        .length;
    final baselineCompleted = _baselineCompletedLessons[topic.id] ?? 0;

    final attempts = <QuizAttemptResult>[];
    for (final quiz in topic.quizzes) {
      final attempt = _quizAttemptsById[quiz.id];
      if (attempt != null) {
        attempts.add(attempt);
      }
    }

    if (attempts.isEmpty && completedLessons == baselineCompleted) {
      return TopicProgress(
        completedLessons: completedLessons,
        masteryPercent:
            _baselineMasteryByTopicId[topic.id] ??
            topic.progress.masteryPercent,
      );
    }

    final lessonPercent = topic.lessons.isEmpty
        ? 100
        : ((completedLessons / topic.lessons.length) * 100).round();

    if (attempts.isEmpty) {
      return TopicProgress(
        completedLessons: completedLessons,
        masteryPercent: lessonPercent,
      );
    }

    final quizPercent =
        (attempts.fold<int>(0, (sum, attempt) => sum + attempt.percent) /
                attempts.length)
            .round();
    final mastery = ((lessonPercent * 0.4) + (quizPercent * 0.6)).round();

    return TopicProgress(
      completedLessons: completedLessons,
      masteryPercent: mastery.clamp(0, 100),
    );
  }

  List<TopicCatalog> getWeakTopics(ExamCatalog exam) {
    final weakTopics = <TopicCatalog>[];
    for (final subject in exam.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          double totalEase = 0;
          int itemWithEaseCount = 0;
          int completedItems = 0;

          for (final lesson in topic.lessons) {
            if (_completedLessonIds.contains(lesson.id)) completedItems++;
            final interval = _srsController.getInterval(lesson.id);
            if (interval != null) {
              totalEase += interval.easeFactor;
              itemWithEaseCount++;
            }
          }
          for (final quiz in topic.quizzes) {
            if (_quizAttemptsById.containsKey(quiz.id)) completedItems++;
            final interval = _srsController.getInterval(quiz.id);
            if (interval != null) {
              totalEase += interval.easeFactor;
              itemWithEaseCount++;
            }
          }

          if (itemWithEaseCount > 0) {
            final avgEase = totalEase / itemWithEaseCount;
            final progress = progressForTopic(topic);
            if (avgEase < 2.0 || (progress.masteryPercent < 40 && completedItems > 0)) {
              weakTopics.add(topic);
            }
          }
        }
      }
    }
    return weakTopics;
  }
}

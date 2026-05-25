import 'dart:math' as math;
import '../../study/domain/learning_models.dart';
import '../../study/state/progress_controller.dart';
import '../../study/state/srs_controller.dart';
import 'engagement_controller.dart';

class SubjectMastery {
  final String subjectName;
  final double completionPercent;
  final int completedLessons;
  final int totalLessons;

  SubjectMastery({
    required this.subjectName,
    required this.completionPercent,
    required this.completedLessons,
    required this.totalLessons,
  });
}

class SrsInventory {
  final int learning;   // 0-1 days
  final int review;     // 1-7 days
  final int mastered;   // >7 days
  final int total;

  SrsInventory({
    required this.learning,
    required this.review,
    required this.mastered,
    required this.total,
  });
}

extension ProgressAnalytics on ProgressController {
  List<SubjectMastery> getSubjectMastery(ExamCatalog exam) {
    return exam.subjects.map((subject) {
      int completed = 0;
      int total = 0;
      
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          total += topic.lessons.length;
          completed += progressForTopic(topic).completedLessons;
        }
      }
      
      return SubjectMastery(
        subjectName: subject.name,
        completionPercent: total == 0 ? 0 : (completed / total),
        completedLessons: completed,
        totalLessons: total,
      );
    }).toList();
  }
}

extension SrsAnalytics on SrsController {
  SrsInventory getSrsInventory(ExamCatalog exam) {
    int learning = 0;
    int review = 0;
    int mastered = 0;
    int total = 0;

    for (final subject in exam.subjects) {
      for (final module in subject.modules) {
        for (final topic in module.topics) {
          for (final lesson in topic.lessons) {
            total++;
            final interval = getInterval(lesson.id);
            if (interval == null) continue;
            
            if (interval.intervalDays <= 1) {
              learning++;
            } else if (interval.intervalDays <= 7) {
              review++;
            } else {
              mastered++;
            }
          }
          for (final quiz in topic.quizzes) {
            total++;
            final interval = getInterval(quiz.id);
            if (interval == null) continue;

            if (interval.intervalDays <= 1) {
              learning++;
            } else if (interval.intervalDays <= 7) {
              review++;
            } else {
              mastered++;
            }
          }
        }
      }
    }

    return SrsInventory(
      learning: learning,
      review: review,
      mastered: mastered,
      total: total,
    );
  }
}

extension EngagementAnalytics on EngagementController {
  List<MapEntry<DateTime, int>> getRecentActivity(int days) {
    final now = DateTime.now();
    final history = metrics.studyHistory;
    
    return List.generate(days, (i) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1 - i));
      final key = date.toIso8601String();
      return MapEntry(date, history[key] ?? 0);
    });
  }
}

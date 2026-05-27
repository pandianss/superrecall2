import 'package:isar/isar.dart';

part 'isar_schemas.g.dart';

@collection
class SrsIntervalSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String itemId;

  late int intervalDays;
  late double easeFactor;
  late DateTime nextReview;
  late int repetitions;
  late double recallStrength;
  late int consecutiveFailures;
}

@collection
class UserProgressSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String lessonId;

  late DateTime completedAt;
}

@collection
class QuizAttemptSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String quizId;

  late int correctCount;
  late int totalQuestions;
  late DateTime attemptedAt;
  int? averageLatencyMs;
}

@collection
class EngagementSchema {
  Id id = 0; // Singleton

  late int totalXp;
  late int currentStreak;
  DateTime? lastStudyDate;
  
  // Isar doesn't support Map directly well, so we store daily XP as a list of embedded objects
  late List<DailyXpEntry> studyHistory;
}

@embedded
class DailyXpEntry {
  late String date; // ISO string
  late int xp;
}

@collection
class AppSettingsSchema {
  Id id = 0; // Singleton

  late int reminderHour;
  late int reminderMinute;
  late bool remindersEnabled;
  int monthsToGoal = 6;
}

@collection
class PurchasedSubjectSchema {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String subjectId;

  late DateTime purchasedAt;
}

@collection
class SessionCheckpointSchema {
  Id id = 0; // Singleton checkpoint per device/user

  late String examId;
  late int currentIndex;
  DateTime? savedAt;
  String? queueJson;
  int? subIndex;
}

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'isar_schemas.dart';

class StorageService {
  Isar? _isar;
  bool get isInitialized => _isar != null;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  AppSettingsSchema? _cachedSettings;

  Future<void> init() async {
    String path = '';
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      path = dir.path;
    }
    
    try {
      _isar = await Isar.open(
        [
          SrsIntervalSchemaSchema,
          UserProgressSchemaSchema,
          QuizAttemptSchemaSchema,
          EngagementSchemaSchema,
          AppSettingsSchemaSchema,
          PurchasedSubjectSchemaSchema,
          SessionCheckpointSchemaSchema,
        ],
        directory: path,
      );
    } catch (e) {
      // Isar might fail on Web or certain environments, continue with null _isar
    }
  }

  // Purchases
  Future<List<String>> getPurchasedSubjects() async {
    if (_isar == null) return [];
    final purchases = await _isar!.purchasedSubjectSchemas.where().findAll();
    return purchases.map((p) => p.subjectId).toList();
  }

  Future<void> saveSubjectPurchase(String subjectId) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.purchasedSubjectSchemas.put(PurchasedSubjectSchema()
        ..subjectId = subjectId
        ..purchasedAt = DateTime.now());
    });
  }

  // Engagement
  Future<Map<String, dynamic>?> getEngagementMetrics() async {
    if (_isar == null) return null;
    final engagement = await _isar!.engagementSchemas.get(0);
    if (engagement == null) return null;
    
    return {
      'totalXp': engagement.totalXp,
      'currentStreak': engagement.currentStreak,
      'lastStudyDate': engagement.lastStudyDate?.toIso8601String(),
      'studyHistory': {
        for (var entry in engagement.studyHistory) entry.date: entry.xp
      },
    };
  }

  Future<void> saveEngagementMetrics(Map<String, dynamic> metrics) async {
    if (_isar == null) return;
    final history = (metrics['studyHistory'] as Map<String, dynamic>?) ?? {};
    
    await _isar!.writeTxn(() async {
      await _isar!.engagementSchemas.put(EngagementSchema()
        ..id = 0
        ..totalXp = metrics['totalXp'] ?? 0
        ..currentStreak = metrics['currentStreak'] ?? 0
        ..lastStudyDate = metrics['lastStudyDate'] != null 
            ? DateTime.parse(metrics['lastStudyDate']) 
            : null
        ..studyHistory = history.entries.map((e) => DailyXpEntry()
            ..date = e.key
            ..xp = e.value).toList(),
      );
    });
  }

  // Progress
  Future<Map<String, dynamic>?> getProgress() async {
    if (_isar == null) return null;
    final lessons = await _isar!.userProgressSchemas.where().findAll();
    final quizzes = await _isar!.quizAttemptSchemas.where().findAll();
    
    final settings = await _getSettings();

    return {
      'completedLessons': {
        for (var l in lessons) l.lessonId: l.completedAt.toIso8601String()
      },
      'quizAttempts': {
        for (var q in quizzes) q.quizId: {
          'correctCount': q.correctCount,
          'totalQuestions': q.totalQuestions,
          'attemptedAt': q.attemptedAt.toIso8601String(),
          'averageLatencyMs': q.averageLatencyMs,
        }
      },
      'monthsToGoal': settings.monthsToGoal,
    };
  }

  Future<void> saveProgress(Map<String, dynamic> data) async {
    if (_isar == null) return;
    final lessonData = data['completedLessons'];
    final quizzes = (data['quizAttempts'] as Map<String, dynamic>?) ?? {};

    await _isar!.writeTxn(() async {
      // Upsert mode: no clear() to avoid data loss if crash occurs mid-save

      if (lessonData is List) {
        for (var lessonId in lessonData) {
          await _isar!.userProgressSchemas.put(UserProgressSchema()
            ..lessonId = lessonId
            ..completedAt = DateTime.now());
        }
      } else if (lessonData is Map) {
        for (var entry in lessonData.entries) {
          await _isar!.userProgressSchemas.put(UserProgressSchema()
            ..lessonId = entry.key
            ..completedAt = DateTime.parse(entry.value));
        }
      }

      for (var entry in quizzes.entries) {
        final val = entry.value as Map<String, dynamic>;
        await _isar!.quizAttemptSchemas.put(QuizAttemptSchema()
          ..quizId = entry.key
          ..correctCount = val['correctCount']
          ..totalQuestions = val['totalQuestions']
          ..attemptedAt = DateTime.parse(val['attemptedAt'])
          ..averageLatencyMs = val['averageLatencyMs']);
      }

      if (data['monthsToGoal'] != null) {
        final settings = await _getSettings();
        settings.monthsToGoal = data['monthsToGoal'];
        _cachedSettings = settings;
        await _isar!.appSettingsSchemas.put(settings);
      }
    });
  }

  // SRS
  Future<Map<String, dynamic>?> getSrsIntervals() async {
    if (_isar == null) return null;
    final intervals = await _isar!.srsIntervalSchemas.where().findAll();
    if (intervals.isEmpty) return null;

    return {
      for (var i in intervals) i.itemId: {
        'itemId': i.itemId,
        'intervalDays': i.intervalDays,
        'easeFactor': i.easeFactor,
        'nextReviewDate': i.nextReview.toIso8601String(),
        'repetitions': i.repetitions,
        'recallStrength': i.recallStrength,
        'consecutiveFailures': i.consecutiveFailures,
      }
    };
  }

  Future<void> saveSrsIntervals(Map<String, dynamic> intervals) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      // Upsert mode: no clear() to avoid data loss
      for (var entry in intervals.entries) {
        final val = entry.value as Map<String, dynamic>;
        await _isar!.srsIntervalSchemas.put(SrsIntervalSchema()
          ..itemId = entry.key
          ..intervalDays = val['intervalDays']
          ..easeFactor = (val['easeFactor'] as num).toDouble()
          ..nextReview = DateTime.parse(val['nextReviewDate'])
          ..repetitions = val['repetitions'] ?? 0
          ..recallStrength = (val['recallStrength'] as num?)?.toDouble() ?? 0.5
          ..consecutiveFailures = val['consecutiveFailures'] ?? 0);
      }
    });
  }

  // Settings
  Future<AppSettingsSchema> _getSettings() async {
    if (_cachedSettings != null) return _cachedSettings!;

    if (_isar == null) {
      return AppSettingsSchema()
        ..id = 0
        ..reminderHour = 19
        ..reminderMinute = 0
        ..remindersEnabled = true;
    }
    _cachedSettings = await _isar!.appSettingsSchemas.get(0) ?? (AppSettingsSchema()
      ..id = 0
      ..reminderHour = 19
      ..reminderMinute = 0
      ..remindersEnabled = true);
    return _cachedSettings!;
  }

  Future<bool> getRemindersEnabled() async {
    final s = await _getSettings();
    return s.remindersEnabled;
  }

  Future<void> saveRemindersEnabled(bool enabled) async {
    if (_isar == null) return;
    final s = await _getSettings();
    s.remindersEnabled = enabled;
    _cachedSettings = s;
    await _isar!.writeTxn(() => _isar!.appSettingsSchemas.put(s));
  }

  Future<String?> getGeminiApiKey() async {
    return await _secureStorage.read(key: 'gemini_api_key');
  }

  Future<void> saveGeminiApiKey(String? key) async {
    if (key == null) {
      await _secureStorage.delete(key: 'gemini_api_key');
    } else {
      await _secureStorage.write(key: 'gemini_api_key', value: key);
    }
  }

  Future<Map<String, int>> getReminderTime() async {
    final s = await _getSettings();
    return {'hour': s.reminderHour, 'minute': s.reminderMinute};
  }

  Future<void> saveReminderTime(int hour, int minute) async {
    if (_isar == null) return;
    final s = await _getSettings();
    s.reminderHour = hour;
    s.reminderMinute = minute;
    _cachedSettings = s;
    await _isar!.writeTxn(() => _isar!.appSettingsSchemas.put(s));
  }
  
  Future<void> clearAll() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() => _isar!.clear());
  }
  
  Future<Map<String, dynamic>> getAllData() async {
    return {
      'progress': await getProgress() ?? {},
      'srs': await getSrsIntervals() ?? {},
      'engagement': await getEngagementMetrics() ?? {},
      'checkpoint': await getSessionCheckpoint() ?? {},
    };
  }

  Future<void> saveAllData(Map<String, dynamic> data) async {
    if (data['progress'] != null) await saveProgress(data['progress']);
    if (data['srs'] != null) await saveSrsIntervals(data['srs']);
    if (data['engagement'] != null) await saveEngagementMetrics(data['engagement']);
    if (data['checkpoint'] != null) await saveSessionCheckpoint(data['checkpoint']);
  }

  // Session checkpoint
  Future<Map<String, dynamic>?> getSessionCheckpoint() async {
    if (_isar == null) return null;
    final chk = await _isar!.sessionCheckpointSchemas.get(0);
    if (chk == null) return null;
    return {
      'examId': chk.examId,
      'currentIndex': chk.currentIndex,
      'savedAt': chk.savedAt?.toIso8601String(),
      'queueJson': chk.queueJson,
      'subIndex': chk.subIndex,
    };
  }

  Future<void> saveSessionCheckpoint(Map<String, dynamic> data) async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      final chk = SessionCheckpointSchema()
        ..id = 0
        ..examId = data['examId'] as String
        ..currentIndex = data['currentIndex'] as int
        ..savedAt = data['savedAt'] != null ? DateTime.parse(data['savedAt']) : DateTime.now()
        ..queueJson = data['queueJson'] as String?
        ..subIndex = data['subIndex'] as int?;
      await _isar!.sessionCheckpointSchemas.put(chk);
    });
  }

  Future<void> clearSessionCheckpoint() async {
    if (_isar == null) return;
    await _isar!.writeTxn(() async {
      await _isar!.sessionCheckpointSchemas.delete(0);
    });
  }
}

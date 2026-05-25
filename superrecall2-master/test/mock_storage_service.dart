import 'package:superrecall/data/local/storage_service.dart';

class MockStorageService extends StorageService {
  Map<String, dynamic>? engagementMetrics;
  Map<String, dynamic>? progress;
  Map<String, dynamic>? srsIntervals;
  bool remindersEnabled = true;
  String? apiKey;
  int reminderHour = 19;
  int reminderMinute = 0;

  @override
  Future<void> init() async {}

  @override
  Future<Map<String, dynamic>?> getEngagementMetrics() async => engagementMetrics;

  @override
  Future<void> saveEngagementMetrics(Map<String, dynamic> metrics) async {
    engagementMetrics = metrics;
  }

  @override
  Future<Map<String, dynamic>?> getProgress() async => progress;

  @override
  Future<void> saveProgress(Map<String, dynamic> data) async {
    progress = data;
  }

  @override
  Future<Map<String, dynamic>?> getSrsIntervals() async => srsIntervals;

  @override
  Future<void> saveSrsIntervals(Map<String, dynamic> intervals) async {
    srsIntervals = intervals;
  }

  @override
  Future<bool> getRemindersEnabled() async => remindersEnabled;

  @override
  Future<void> saveRemindersEnabled(bool enabled) async {
    remindersEnabled = enabled;
  }

  @override
  Future<String?> getGeminiApiKey() async => apiKey;

  @override
  Future<void> saveGeminiApiKey(String? key) async {
    apiKey = key;
  }

  @override
  Future<Map<String, int>> getReminderTime() async => {'hour': reminderHour, 'minute': reminderMinute};

  @override
  Future<void> saveReminderTime(int hour, int minute) async {
    reminderHour = hour;
    reminderMinute = minute;
  }

  @override
  Future<void> clearAll() async {
    engagementMetrics = null;
    progress = null;
    srsIntervals = null;
  }
}

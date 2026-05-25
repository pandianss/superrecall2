import 'package:flutter/material.dart';
import '../../../data/local/storage_service.dart';

class SettingsController extends ChangeNotifier {
  final StorageService _storage;

  SettingsController(this._storage);

  String? _geminiApiKey;
  String? get geminiApiKey => _geminiApiKey;

  TimeOfDay _reminderTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay get reminderTime => _reminderTime;

  Future<void> init() async {
    _geminiApiKey = await _storage.getGeminiApiKey();
    final time = await _storage.getReminderTime();
    _reminderTime = TimeOfDay(
      hour: time['hour']!,
      minute: time['minute']!,
    );
    notifyListeners();
  }

  Future<void> setGeminiApiKey(String? key) async {
    _geminiApiKey = key;
    await _storage.saveGeminiApiKey(key);
    notifyListeners();
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    _reminderTime = time;
    await _storage.saveReminderTime(time.hour, time.minute);
    notifyListeners();
  }
}

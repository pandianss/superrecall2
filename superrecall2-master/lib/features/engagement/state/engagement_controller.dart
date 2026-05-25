import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:clock/clock.dart';

import '../domain/engagement_models.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/remote/sync_service.dart';

class EngagementController extends ChangeNotifier {
  final StorageService _storage;
  final SyncService _syncService;

  EngagementController(this._storage, this._syncService) {
    _syncService.authEvents.listen((event) {
      if (event == AuthEvent.logout) {
        _clearInMemory();
      }
    });
  }

  void _clearInMemory() {
    _metrics = EngagementMetrics.empty();
    notifyListeners();
  }

  EngagementMetrics _metrics = EngagementMetrics.empty();
  EngagementMetrics get metrics => _metrics;

  final _xpStreamController = StreamController<int>.broadcast();
  Stream<int> get xpEarnedStream => _xpStreamController.stream;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    final saved = await _storage.getEngagementMetrics();
    if (saved != null) {
      _metrics = EngagementMetrics.fromJson(saved);
    }
    _checkStreak();
    _isLoaded = true;
    notifyListeners();
  }

  void _checkStreak() {
    if (_metrics.lastStudyDate == null) return;

    final now = clock.now();
    final lastStudy = _metrics.lastStudyDate!;
    final difference = DateTime(now.year, now.month, now.day)
        .difference(DateTime(lastStudy.year, lastStudy.month, lastStudy.day))
        .inDays;

    if (difference > 1) {
      // Streak broken
      _metrics = EngagementMetrics(
        totalXp: _metrics.totalXp,
        currentStreak: 0,
        lastStudyDate: _metrics.lastStudyDate,
        studyHistory: _metrics.studyHistory,
      );
      _save();
    }
  }

  void recordActivity(int baseXp) {
    _checkStreak();
    final now = clock.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();
    
    int streakBonus = _metrics.currentStreak * 10;
    if (streakBonus > 100) streakBonus = 100;

    final totalEarned = baseXp + streakBonus;

    int newStreak = _metrics.currentStreak;
    if (_metrics.lastStudyDate == null) {
      newStreak = 1;
    } else {
      final lastStudy = _metrics.lastStudyDate!;
      final difference = DateTime(now.year, now.month, now.day)
          .difference(DateTime(lastStudy.year, lastStudy.month, lastStudy.day))
          .inDays;
      
      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1;
      }
    }

    final newHistory = Map<String, int>.from(_metrics.studyHistory);
    newHistory[todayStr] = (newHistory[todayStr] ?? 0) + totalEarned;

    _metrics = EngagementMetrics(
      totalXp: _metrics.totalXp + totalEarned,
      currentStreak: newStreak,
      lastStudyDate: now,
      studyHistory: newHistory,
    );

    _save();
    _xpStreamController.add(totalEarned);
    notifyListeners();
  }

  @override
  void dispose() {
    _xpStreamController.close();
    super.dispose();
  }

  void _save() {
    _storage.saveEngagementMetrics(_metrics.toJson());
    _syncService.pushLocalProgress();
  }
}

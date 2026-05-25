import 'package:flutter/widgets.dart';
import 'package:clock/clock.dart';
import '../domain/srs_models.dart';
import '../../../data/local/storage_service.dart';
import '../../../data/remote/sync_service.dart';

class SrsController extends ChangeNotifier {
  final StorageService _storage;
  final SyncService _syncService;
  
  SrsController(this._storage, this._syncService) {
    _syncService.authEvents.listen((event) {
      if (event == AuthEvent.logout) {
        _clearInMemory();
      }
    });
  }

  void _clearInMemory() {
    _reviewIntervals.clear();
    notifyListeners();
  }

  final Map<String, ReviewInterval> _reviewIntervals = {};
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    final data = await _storage.getSrsIntervals();
    if (data != null) {
      data.forEach((key, value) {
        _reviewIntervals[key] = ReviewInterval.fromJson(Map<String, dynamic>.from(value));
      });
    }
    _isLoaded = true;
    notifyListeners();
  }

  DateTime? get nextGlobalReviewDate {
    if (_reviewIntervals.isEmpty) return null;
    DateTime? earliest;
    for (final interval in _reviewIntervals.values) {
      if (earliest == null || interval.nextReviewDate.isBefore(earliest)) {
        earliest = interval.nextReviewDate;
      }
    }
    return earliest;
  }

  int getDueCountAt(DateTime date) {
    var count = 0;
    for (final interval in _reviewIntervals.values) {
      if (interval.nextReviewDate.isBefore(date) || interval.nextReviewDate.isAtSameMomentAs(date)) {
        count++;
      }
    }
    return count;
  }

  ReviewInterval? getInterval(String itemId) => _reviewIntervals[itemId];

  void scheduleReview(String itemId, int quality) {
    assert(quality >= 0 && quality <= 5);
    final existing = _reviewIntervals[itemId];
    final now = clock.now();

    int newInterval;
    double newEase;
    int newRepetitions;

    if (existing == null) {
      if (quality >= 3) {
        newInterval = 1;
        newEase = 2.5;
        newRepetitions = 1;
      } else {
        newInterval = 0; // Immediate re-review
        newEase = 2.5;
        newRepetitions = 0;
      }
    } else {
      newEase = (existing.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))).clamp(1.3, 3.0);
      
      if (quality < 3) {
        newInterval = 1;
        newRepetitions = 0;
      } else {
        newRepetitions = existing.repetitions + 1;
        if (newRepetitions == 1) {
          newInterval = 1;
        } else if (newRepetitions == 2) {
          newInterval = 6;
        } else {
          newInterval = (existing.intervalDays * newEase).round();
        }
      }
    }

    newInterval = newInterval.clamp(0, 3650);

    _reviewIntervals[itemId] = ReviewInterval(
      itemId: itemId,
      nextReviewDate: now.add(Duration(days: newInterval)),
      lastReviewedDate: now,
      intervalDays: newInterval,
      easeFactor: newEase,
      repetitions: newRepetitions,
    );
    
    _storage.saveSrsIntervals(_reviewIntervals.map(
      (key, value) => MapEntry(key, value.toJson()),
    ));
    _syncService.pushLocalProgress();
    notifyListeners();
  }
}

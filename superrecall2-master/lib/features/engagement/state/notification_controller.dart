import 'package:flutter/widgets.dart';
import 'package:clock/clock.dart';
import 'dart:async';
import 'notification_service.dart';
import 'engagement_controller.dart';
import '../../study/state/srs_controller.dart';

class NotificationController extends ChangeNotifier {
  final NotificationService _service;
  final EngagementController _engagementController;
  final SrsController _srsController;
  Timer? _updateTimer;
  Future<void>? _pendingUpdate;

  NotificationController(
    this._service,
    this._engagementController,
    this._srsController,
  ) {
    _engagementController.addListener(_onControllerChanged);
    _srsController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _engagementController.removeListener(_onControllerChanged);
    _srsController.removeListener(_onControllerChanged);
    _updateTimer?.cancel();
    super.dispose();
  }

  void _onControllerChanged() {
    _updateTimer?.cancel();
    _updateTimer = Timer(const Duration(milliseconds: 500), () async {
      final currentUpdate = _pendingUpdate;
      final newUpdate = () async {
        if (currentUpdate != null) {
          try {
            await currentUpdate;
          } catch (_) {}
        }
        await updateReminders();
      }();
      _pendingUpdate = newUpdate;
      await newUpdate;
    });
  }

  bool _remindersEnabled = true;
  bool get remindersEnabled => _remindersEnabled;

  void toggleReminders(bool value) {
    _remindersEnabled = value;
    if (value) {
      updateReminders();
    } else {
      _service.cancelAll();
    }
    notifyListeners();
  }

  Future<void> updateReminders() async {
    if (!_remindersEnabled) return;

    await _service.cancelAll();

    // 1. Streak Reminder
    final now = clock.now();
    final lastStudy = _engagementController.metrics.lastStudyDate;
    final didStudyToday = lastStudy != null &&
        lastStudy.year == now.year &&
        lastStudy.month == now.month &&
        lastStudy.day == now.day;

    if (!didStudyToday) {
      // Schedule for 7:00 PM today (or tomorrow if already past 7 PM)
      await _service.scheduleStreakReminder(19, 0);
    }

    // 2. Next Review Reminder
    final nextReviewDate = _srsController.nextGlobalReviewDate;
    if (nextReviewDate != null && nextReviewDate.isAfter(now)) {
      final dueCount = _srsController.getDueCountAt(nextReviewDate);
      if (dueCount > 0) {
        await _service.scheduleReviewReminder(nextReviewDate, dueCount);
      }
    }
  }
}

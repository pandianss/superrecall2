import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) return;
    
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    if (kIsWeb) return;

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> scheduleStreakReminder(int hour, int minute) async {
    if (kIsWeb) return;

    try {
      await _notificationsPlugin.zonedSchedule(
        id: 0,
        title: 'Don\'t break your streak! 🔥',
        body: 'Take 5 minutes to complete a quick lesson and keep your progress alive.',
        scheduledDate: _nextInstanceOfTime(hour, minute),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'streak_reminders',
            'Streak Reminders',
            channelDescription: 'Reminders to study and maintain your streak',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Exact alarm scheduling failed, falling back to approximate: $e');
      try {
        await _notificationsPlugin.zonedSchedule(
          id: 0,
          title: 'Don\'t break your streak! 🔥',
          body: 'Take 5 minutes to complete a quick lesson and keep your progress alive.',
          scheduledDate: _nextInstanceOfTime(hour, minute),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'streak_reminders',
              'Streak Reminders',
              channelDescription: 'Reminders to study and maintain your streak',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (inner) {
        debugPrint('Approximate alarm scheduling failed: $inner');
      }
    }
  }

  Future<void> scheduleReviewReminder(DateTime scheduledTime, int count) async {
    if (kIsWeb) return;

    try {
      await _notificationsPlugin.zonedSchedule(
        id: 1,
        title: 'Revision queue ready 📚',
        body: 'You have $count items ready for review. Consistency is key to long-term retention!',
        scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'review_reminders',
            'Review Reminders',
            channelDescription: 'Notifications when spaced repetition reviews are due',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Exact alarm scheduling failed for review, falling back to approximate: $e');
      try {
        await _notificationsPlugin.zonedSchedule(
          id: 1,
          title: 'Revision queue ready 📚',
          body: 'You have $count items ready for review. Consistency is key to long-term retention!',
          scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'review_reminders',
              'Review Reminders',
              channelDescription: 'Notifications when spaced repetition reviews are due',
              importance: Importance.defaultImportance,
              priority: Priority.defaultPriority,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (inner) {
        debugPrint('Approximate alarm scheduling failed for review: $inner');
      }
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await _notificationsPlugin.cancelAll();
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

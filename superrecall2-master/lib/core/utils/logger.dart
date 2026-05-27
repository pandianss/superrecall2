import 'dart:developer' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'INFO', error: error, stackTrace: stackTrace, level: 800);
    
    // Log info as a custom event in Analytics
    logEvent('app_info', {
      'message': message.length > 100 ? message.substring(0, 100) : message,
    });
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'WARNING', error: error, stackTrace: stackTrace, level: 900);
    
    // Log warnings to Analytics
    logEvent('app_warning', {
      'message': message.length > 100 ? message.substring(0, 100) : message,
    });
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'ERROR', error: error, stackTrace: stackTrace, level: 1000);
    
    // Send errors to Crashlytics
    if (!kIsWeb) {
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
      );
    }
    
    // Also log to Analytics
    logEvent('app_error', {
      'message': message.length > 100 ? message.substring(0, 100) : message,
    });
  }

  static Future<void> logEvent(String name, [Map<String, Object?>? parameters]) async {
    try {
      final Map<String, Object>? sanitized = parameters == null
          ? null
          : Map<String, Object>.fromEntries(
              parameters.entries.where((e) => e.value != null).map((e) => MapEntry(e.key, e.value as Object)),
            );
      await _analytics.logEvent(name: name, parameters: sanitized);
    } catch (_) {
      // Ignore analytics failure silently.
    }
  }

  static Future<void> logScreenView(String screenName, [Map<String, Object?>? parameters]) async {
    await logEvent('screen_view', {
      'screen_name': screenName,
      ...?parameters,
    });
  }
}

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
    _analytics.logEvent(
      name: 'app_info',
      parameters: {
        'message': message.length > 100 ? message.substring(0, 100) : message,
      },
    );
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: 'WARNING', error: error, stackTrace: stackTrace, level: 900);
    
    // Log warnings to Analytics
    _analytics.logEvent(
      name: 'app_warning',
      parameters: {
        'message': message.length > 100 ? message.substring(0, 100) : message,
      },
    );
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
    _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'message': message.length > 100 ? message.substring(0, 100) : message,
      },
    );
  }
}

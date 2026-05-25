import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'core/config/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final options = DefaultFirebaseOptions.currentPlatform;
    if (options.apiKey.isNotEmpty) {
      await Firebase.initializeApp(options: options);
      
      // Pass all uncaught errors from the framework to Crashlytics.
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
        
        // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }
    } else {
      debugPrint('Firebase API Key is missing. Skipping initialization.');
    }
  } catch (e) {
    // If initialization fails (e.g. platform not configured), log it and continue
    debugPrint('Firebase initialization failed: $e');
  }

  runApp(const SuperRecallApp());
}

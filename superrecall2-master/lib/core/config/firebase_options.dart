import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
        return web;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyChV4bgHS-PPP_MG62nLfba_FtLO2yYnQA',
    appId: '1:575245399071:web:ecc548f46b3979ccd1112a',
    messagingSenderId: '575245399071',
    projectId: 'srecall',
    authDomain: 'srecall.firebaseapp.com',
    storageBucket: 'srecall.firebasestorage.app',
    measurementId: 'G-DG1GSCNJT0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChV4bgHS-PPP_MG62nLfba_FtLO2yYnQA',
    appId: '1:575245399071:android:ecc548f46b3979ccd1112a',
    messagingSenderId: '575245399071',
    projectId: 'srecall',
    storageBucket: 'srecall.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChV4bgHS-PPP_MG62nLfba_FtLO2yYnQA',
    appId: '1:575245399071:ios:ecc548f46b3979ccd1112a',
    messagingSenderId: '575245399071',
    projectId: 'srecall',
    storageBucket: 'srecall.firebasestorage.app',
    iosBundleId: 'com.pandian.superrecall',
  );
}

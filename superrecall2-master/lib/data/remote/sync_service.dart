import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../local/storage_service.dart';
import '../../core/utils/logger.dart';

enum AuthEvent { login, logout }

class SyncService {
  final StorageService _storage;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  Timer? _debounceTimer;

  final _authEventController = StreamController<AuthEvent>.broadcast();
  Stream<AuthEvent> get authEvents => _authEventController.stream;

  SyncService(
    this._storage, {
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  String? get userId => _auth.currentUser?.uid;
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;
  String? get userEmail => _auth.currentUser?.email;

  Future<void> initialize() async {
    // Started offline-first. No anonymous sign-in on launch.
    if (_auth.currentUser != null) {
      AppLogger.info('Session active on startup: $userId');
    }
  }

  /// Pushes local state to Firestore with a debounce
  void pushLocalProgress() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 3), () async {
      final uid = userId;
      if (uid == null) return;

      try {
        final data = await _storage.getAllData();

        await _firestore.collection('users').doc(uid).set({
          'data': data,
          'lastSyncedAt': FieldValue.serverTimestamp(),
          'email': userEmail,
        }, SetOptions(merge: true));
        
        AppLogger.info('Pushed full state to cloud');
      } catch (e, st) {
        AppLogger.error('Cloud push failed', e, st);
      }
    });
  }

  /// Pulls remote state and merges with local
  Future<void> pullRemoteProgress() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        AppLogger.info('Signed in anonymously for on-demand sync: $userId');
      } catch (e, st) {
        AppLogger.error('Cloud pull anonymous sign-in failed', e, st);
        return;
      }
    }
    final uid = userId;
    if (uid == null) return;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return;

      final remoteData = doc.data();
      if (remoteData == null || remoteData['data'] == null) return;

      final remoteMap = Map<String, dynamic>.from(remoteData['data']);
      final localMap = await _storage.getAllData();

      // Simple Union Merge Strategy
      final mergedData = mergeData(localMap, remoteMap);
      
      await _storage.saveAllData(mergedData);
      AppLogger.info('Merged local state with cloud state');
    } catch (e, st) {
      AppLogger.error('Cloud pull/merge failed', e, st);
    }
  }

  Map<String, dynamic> mergeData(Map<String, dynamic> local, Map<String, dynamic> remote) {
    final result = Map<String, dynamic>.from(local);

    // Merge Progress
    final localProg = Map<String, dynamic>.from(local['progress'] ?? {});
    final remoteProg = Map<String, dynamic>.from(remote['progress'] ?? {});
    
    final mergedProg = Map<String, dynamic>.from(localProg);
    if (remoteProg['completedLessons'] != null) {
      final localLessons = Map<String, dynamic>.from(localProg['completedLessons'] ?? {});
      final remoteLessons = Map<String, dynamic>.from(remoteProg['completedLessons'] ?? {});
      mergedProg['completedLessons'] = {...remoteLessons, ...localLessons}; // Local wins for same key
    }
    if (remoteProg['quizAttempts'] != null) {
      final localQuizzes = Map<String, dynamic>.from(localProg['quizAttempts'] ?? {});
      final remoteQuizzes = Map<String, dynamic>.from(remoteProg['quizAttempts'] ?? {});
      mergedProg['quizAttempts'] = {...remoteQuizzes, ...localQuizzes};
    }
    // monthsToGoal: Local wins for consistency with lessons/SRS.
    mergedProg['monthsToGoal'] = localProg['monthsToGoal'] ?? remoteProg['monthsToGoal'] ?? 6;
    result['progress'] = mergedProg;

    // Merge SRS
    final localSrs = Map<String, dynamic>.from(local['srs'] ?? {});
    final remoteSrs = Map<String, dynamic>.from(remote['srs'] ?? {});
    result['srs'] = {...remoteSrs, ...localSrs};

    // Merge Engagement
    final localEng = Map<String, dynamic>.from(local['engagement'] ?? {});
    final remoteEng = Map<String, dynamic>.from(remote['engagement'] ?? {});
    result['engagement'] = {
      ...remoteEng,
      ...localEng,
      'totalXp': (localEng['totalXp'] ?? 0) > (remoteEng['totalXp'] ?? 0) 
          ? localEng['totalXp'] 
          : remoteEng['totalXp'],
      'currentStreak': (localEng['currentStreak'] ?? 0) > (remoteEng['currentStreak'] ?? 0)
          ? localEng['currentStreak']
          : remoteEng['currentStreak'],
    };

    return result;
  }

  Future<void> linkWithEmail(String email, String password) async {
    // If current session is null, anonymous sign in first
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
    final user = _auth.currentUser;
    if (user == null) return;

    final credential = EmailAuthProvider.credential(email: email, password: password);
    
    try {
      await user.linkWithCredential(credential);
      AppLogger.info('Account linked successfully');
      _authEventController.add(AuthEvent.login);
      pushLocalProgress(); // Force push to save email
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        // If account exists, sign in instead and merge data manually
        await _auth.signInWithCredential(credential);
        _authEventController.add(AuthEvent.login);
        await pullRemoteProgress();
      } else {
        rethrow;
      }
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    _authEventController.add(AuthEvent.login);
    await pullRemoteProgress();
  }

  Future<void> signOut() async {
    final wasAnonymous = isAnonymous;
    await _auth.signOut();
    if (!wasAnonymous) {
      _authEventController.add(AuthEvent.logout);
      await _storage.clearAll();
    }
    await initialize(); // Re-sign in anonymously if needed or trigger sessions
  }
}

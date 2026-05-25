import 'dart:async';
import 'package:superrecall/data/remote/sync_service.dart';

class MockSyncService implements SyncService {
  int pushCount = 0;
  int pullCount = 0;

  final _authEventController = StreamController<AuthEvent>.broadcast();

  @override
  Stream<AuthEvent> get authEvents => _authEventController.stream;

  void emitLogout() {
    _authEventController.add(AuthEvent.logout);
  }

  @override
  String? get userId => 'mock_user_id';

  @override
  Future<void> initialize() async {}

  @override
  void pushLocalProgress() {
    pushCount++;
  }

  @override
  Future<void> pullRemoteProgress() async {
    pullCount++;
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

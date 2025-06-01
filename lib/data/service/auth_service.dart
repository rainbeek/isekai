import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/session.dart';

final sessionStateProvider = StateNotifierProvider<SessionState, Session?>(
  (ref) => SessionState(),
);

final Provider<AuthActions> authActionsProvider = Provider(
  (ref) => AuthActions(),
);

class SessionState extends StateNotifier<Session?> {
  SessionState() : super(null);

  StreamSubscription<Session?>? _sessionSubscription;

  @override
  Future<void> dispose() async {
    await _sessionSubscription?.cancel();

    super.dispose();
  }

  Future<void> initialize() async {
    final session = await _currentSession();
    state = session;

    _sessionSubscription = FirebaseAuth.instance
        .authStateChanges()
        .asyncMap((user) {
          if (user == null) {
            return null;
          }

          return _convertUserToLoginSession(user);
        })
        .listen((session) {
          state = session;
        });
  }

  Future<Session?> _currentSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      return _convertUserToLoginSession(user);
    } on FirebaseAuthException {
      // TODO(ide): Firebase Emulator環境だとエラーが発生することがあるので、暫定対応
      await FirebaseAuth.instance.signOut();
    }

    return null;
  }

  Session _convertUserToLoginSession(User user) {
    return Session(userId: user.uid);
  }
}

class AuthActions {
  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();

    final userId = credential.user?.uid;
    final token = await credential.user?.getIdToken();

    debugPrint('Signed in anonymously: userId: $userId, token: $token');
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

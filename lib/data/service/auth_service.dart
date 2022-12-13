// ignore_for_file: prefer-match-file-name

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/model/login_session.dart';

final sessionStreamProvider = StreamProvider<LoginSession>((ref) {
  final maybeSession = ref.watch(_sessionProvider);

  if (maybeSession == null) {
    return const Stream.empty();
  }

  return Stream.value(maybeSession);
});

final authActionsProvider = Provider(
  (ref) => AuthActions(),
);

class AuthActions {
  Future<void> signInAnonymously() async {
    final credential = await FirebaseAuth.instance.signInAnonymously();
    final idToken = await credential.user?.getIdToken();
    debugPrint('Signed in anonymously: $idToken');
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

final _sessionProvider = StateNotifierProvider<_SessionProvider, LoginSession?>(
  (ref) => _SessionProvider(),
);

class _SessionProvider extends StateNotifier<LoginSession?> {
  _SessionProvider() : super(null);

  StreamSubscription<LoginSession?>? _sessionSubscription;

  @override
  Future<void> dispose() async {
    await _sessionSubscription?.cancel();

    super.dispose();
  }

  Future<void> setup() async {
    final session = await _currentSession();
    state = session;

    _sessionSubscription = FirebaseAuth.instance.authStateChanges().asyncMap(
      (user) async {
        if (user == null) {
          return null;
        }

        final token = await user.getIdToken();

        return LoginSession(userId: user.uid, token: token);
      },
    ).listen((session) {
      state = session;
    });
  }

  Future<LoginSession?> _currentSession() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;
      }

      final token = await user.getIdToken();

      return LoginSession(userId: user.uid, token: token);
    } on FirebaseAuthException {
      // TODO(ide): Firebase Emulator環境だとエラーが発生することがあるので、暫定対応
      await FirebaseAuth.instance.signOut();
    }

    return null;
  }
}

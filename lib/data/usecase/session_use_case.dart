// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/service/auth_service.dart';

final sessionActionsProvider = Provider(
  (ref) => SessionActions(
    sessionState: ref.watch(sessionProvider.notifier),
    authActions: ref.watch(authActionsProvider),
    ref: ref,
  ),
);

class SessionActions {
  const SessionActions({
    required SessionState sessionState,
    required AuthActions authActions,
    required Ref ref,
  })  : _sessionState = sessionState,
        _authActions = authActions,
        _ref = ref;

  final SessionState _sessionState;
  final AuthActions _authActions;
  final Ref _ref;

  Future<void> ensureLoggedIn() async {
    await _sessionState.initialize();

    final session = _ref.read(sessionProvider);
    if (session != null) {
      return;
    }

    await _authActions.signInAnonymously();
  }
}

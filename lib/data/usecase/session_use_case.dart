import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/session.dart';
import 'package:isekai/data/service/auth_service.dart';

/// セッションが生成されるまで待ち、not-nullの型で取得するためのプロバイダー
final FutureProvider<Session> forceSessionProvider = FutureProvider((
  ref,
) async {
  return ref.watch(_sessionStreamProvider.future);
});

final Provider<SessionActions> sessionActionsProvider = Provider(
  (ref) => SessionActions(
    sessionState: ref.watch(sessionStateProvider.notifier),
    authActions: ref.watch(authActionsProvider),
    ref: ref,
  ),
);

final _sessionStreamProvider = StreamProvider<Session>((ref) {
  final maybeSession = ref.watch(sessionStateProvider);

  if (maybeSession == null) {
    return const Stream.empty();
  }

  return Stream.value(maybeSession);
});

class SessionActions {
  const SessionActions({
    required SessionState sessionState,
    required AuthActions authActions,
    required Ref ref,
  }) : _sessionState = sessionState,
       _authActions = authActions,
       _ref = ref;

  final SessionState _sessionState;
  final AuthActions _authActions;
  final Ref _ref;

  Future<void> ensureLoggedIn() async {
    await _sessionState.initialize();

    final session = _ref.read(sessionStateProvider);
    if (session != null) {
      return;
    }

    await _authActions.signInAnonymously();
  }
}

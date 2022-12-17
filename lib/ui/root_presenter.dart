import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';

class RootPresenter extends StateNotifier<bool> {
  RootPresenter({
    required SessionActions sessionActions,
  }) : super(false) {
    _setup(sessionActions: sessionActions);
  }

  Future<void> _setup({
    required SessionActions sessionActions,
  }) async {
    await sessionActions.ensureLoggedIn();

    state = true;
  }
}

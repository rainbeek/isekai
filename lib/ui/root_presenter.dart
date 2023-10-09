import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/usecase/preference_use_case.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';

class RootPresenter extends StateNotifier<bool> {
  RootPresenter({
    required SessionActions sessionActions,
    required PreferenceActions preferenceActions,
  }) : super(false) {
    _setup(
      sessionActions: sessionActions,
      preferenceActions: preferenceActions,
    );
  }

  Future<void> _setup({
    required SessionActions sessionActions,
    required PreferenceActions preferenceActions,
  }) async {
    await sessionActions.ensureLoggedIn();
    await preferenceActions.ensureProfileLoaded();

    state = true;
  }
}

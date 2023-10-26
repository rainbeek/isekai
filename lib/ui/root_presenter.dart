import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/service/remote_config_service.dart';
import 'package:isekai/data/usecase/app_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/data/usecase/session_use_case.dart';
import 'package:isekai/ui/start_page.dart';

class RootPresenter extends StateNotifier<StartPage?> {
  RootPresenter({
    required SessionActions sessionActions,
    required PreferenceActions preferenceActions,
    required Ref ref,
  })  : _ref = ref,
        super(null) {
    _setup(
      sessionActions: sessionActions,
      preferenceActions: preferenceActions,
    );
  }

  final Ref _ref;

  Timer? _timer;

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _setup({
    required SessionActions sessionActions,
    required PreferenceActions preferenceActions,
  }) async {
    await sessionActions.ensureLoggedIn();
    await preferenceActions.ensureValidProfileLoaded();
    await _ref.read(ensureActivateFetchedRemoteConfigsActionProvider).call();

    final shouldUpdateApp = await _ref.read(shouldUpdateAppProvider.future);
    if (shouldUpdateApp) {
      state = StartPage.updateApp;
    } else {
      state = StartPage.home;
    }

    _timer = Timer.periodic(const Duration(minutes: 5), (_) async {
      await preferenceActions.updateProfileIfNeeded();
    });

    _ref.listen<Future<Set<String>>>(
      updatedRemoteConfigKeysProvider.future,
      (_, next) async {
        // リモート設定の変更を監視し、次回アプリが起動する際にそれらがアクティブになるようにする。
        // ここでは何もしていないが、リモート設定のライブラリが変更された値を保持する。
        // https://firebase.google.com/docs/remote-config/loading#strategy_3_load_new_values_for_next_startup
        final configKeys = await next;

        debugPrint('Updated remote config keys: $configKeys');
      },
      fireImmediately: true,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/service/auth_service.dart';

class RootPresenter extends StateNotifier<bool> {
  RootPresenter({
    required Ref ref,
  }) : super(false) {
    _setup(ref: ref);
  }

  Future<void> _setup({
    required Ref ref,
  }) async {
    await ref.read(ensureLoggedInActionProvider.future);

    state = true;
  }
}

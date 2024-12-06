import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/usecase/message_use_case.dart';

class PostMessagePresenter {
  PostMessagePresenter({
    required MessageActions messageActions,
    required PreferenceActions preferenceActions,
    required Ref ref,
  })  : _messageActions = messageActions,
        _preferenceActions = preferenceActions,
        _ref = ref;

  final MessageActions _messageActions;
  final PreferenceActions _preferenceActions;
  final Ref _ref;

  late Future<ConfirmResultWithDoNotShowAgainOption?> Function({
    required Profile profile,
  }) showConfirmDialog;

  Future<void> sendMessage({required String text}) async {
    final shouldExplainProfileLifecycle =
        await _preferenceActions.getShouldExplainProfileLifecycle();
    if (shouldExplainProfileLifecycle) {
      final profile = _ref.read(profileProvider);
      if (profile == null) {
        return;
      }

      final result = await showConfirmDialog(profile: profile);

      if (result == null) {
        return;
      }

      final doNotShowAgain = result.maybeWhen(
        doContinue: (doNotShowAgain) => doNotShowAgain,
        orElse: () => null,
      );
      final cancelled = doNotShowAgain == null;
      if (cancelled) {
        return;
      }

      if (doNotShowAgain) {
        await _preferenceActions.userRequestedDoNotShowAgainProfileLifecycle();
      }
    }

    await _messageActions.sendMessage(text: text);
  }
}

import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';

class ThreadPresenter {
  ThreadPresenter({
    required MessageActions messageActions,
    required PreferenceActions preferenceActions,
  })  : _messageActions = messageActions,
        _preferenceActions = preferenceActions;

  final MessageActions _messageActions;
  final PreferenceActions _preferenceActions;

  late Future<ConfirmResultWithDoNotShowAgainOption?> Function()
      showConfirmDialog;

  Future<void> sendMessage({required String text}) async {
    final hasShownDialog = await _preferenceActions.loadFirstMessageFlag();
    if (!hasShownDialog) {
      final result = await showConfirmDialog();

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
        await _preferenceActions.saveFirstMessageFlag(value: true);
      }
    }

    await _messageActions.sendMessage(text: text);
  }
}

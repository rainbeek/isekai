import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/profile.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/ui/model/confirm_result_with_do_not_show_again_option.dart';

final postMessagePresenterProvider = Provider(
  (ref) => PostMessagePresenter(
    messageActions: ref.watch(messageActionsProvider),
    preferenceActions: ref.watch(preferenceActionsProvider),
    ref: ref,
  ),
);

final canPostMessageOnPostMessageScreenProvider =
    StateNotifierProvider<_CanPostMessageNotifier, bool>(
      (ref) => _CanPostMessageNotifier(),
    );

class PostMessagePresenter {
  PostMessagePresenter({
    required MessageActions messageActions,
    required PreferenceActions preferenceActions,
    required Ref ref,
  }) : _messageActions = messageActions,
       _preferenceActions = preferenceActions,
       _ref = ref;

  static const int maxMessageLength = 140;

  final MessageActions _messageActions;
  final PreferenceActions _preferenceActions;
  final Ref _ref;

  late Future<ConfirmResultWithDoNotShowAgainOption?> Function({
    required Profile profile,
  })
  _showConfirmDialog;
  late void Function() _close;

  void registerListeners({
    required Future<ConfirmResultWithDoNotShowAgainOption?> Function({
      required Profile profile,
    })
    showConfirmDialog,
    required void Function() close,
  }) {
    _showConfirmDialog = showConfirmDialog;
    _close = close;
  }

  void onChangeMessage(String message) {
    _ref
        .read(canPostMessageOnPostMessageScreenProvider.notifier)
        .onChangeMessage(message);
  }

  Future<void> sendMessage({required String text}) async {
    final shouldExplainProfileLifecycle =
        await _preferenceActions.getShouldExplainProfileLifecycle();
    if (shouldExplainProfileLifecycle) {
      final profile = _ref.read(profileProvider);
      if (profile == null) {
        return;
      }

      final result = await _showConfirmDialog(profile: profile);
      if (result == null) {
        return;
      }

      final bool? doNotShowAgain;
      switch (result) {
        case ConfirmResultWithDoNotShowAgainOptionContinued(
          doNotShowAgain: final doNotShowAgainValue,
        ):
          doNotShowAgain = doNotShowAgainValue;
        case ConfirmResultWithDoNotShowAgainOptionCanceled():
          doNotShowAgain = null;
      }
      final cancelled = doNotShowAgain == null;
      if (cancelled) {
        return;
      }

      if (doNotShowAgain) {
        await _preferenceActions.userRequestedDoNotShowAgainProfileLifecycle();
      }
    }

    // TODO(ide): ローディングを表示する

    await _messageActions.sendMessage(text: text);

    _close();
  }
}

class _CanPostMessageNotifier extends StateNotifier<bool> {
  _CanPostMessageNotifier() : super(false);

  Future<void> onChangeMessage(String message) async {
    state = message.isNotEmpty && message.trim().isNotEmpty;
  }
}

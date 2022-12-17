import 'package:live_bresto/data/usecase/message_use_case.dart';

class ThreadPresenter {
  ThreadPresenter({
    required MessageActions messageActions,
  }) : _messageActions = messageActions;

  final MessageActions _messageActions;

  Future<void> sendMessage({required String text}) async {
    await _messageActions.sendMessage(text: text);
  }
}

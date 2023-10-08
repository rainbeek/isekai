// ignore_for_file: prefer-match-file-name

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/definitions/app_mode.dart';
import 'package:live_bresto/data/service/database_service.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';

final currentThreadMessagesProvider = StreamProvider((ref) {
  return ref.watch(threadMessagesProvider(threadIdForDebug).stream);
});

final messageActionsProvider = Provider(
  (ref) => MessageActions(
    databaseActions: ref.watch(databaseActionsProvider),
    ref: ref,
  ),
);

class MessageActions {
  const MessageActions({
    required DatabaseActions databaseActions,
    required Ref ref,
  })  : _databaseActions = databaseActions,
        _ref = ref;

  final Ref _ref;
  final DatabaseActions _databaseActions;

  Future<void> sendMessage({required String text}) async {
    final session = await _ref.read(forceSessionProvider.future);
    const threadId = threadIdForDebug;

    await _databaseActions.sendMessage(
      threadId: threadId,
      text: text,
      userId: session.userId,
      createdAt: DateTime.now(),
    );
  }
}

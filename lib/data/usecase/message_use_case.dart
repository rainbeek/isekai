import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/definition/app_mode.dart';
import 'package:isekai/data/model/message.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/service/database_service.dart';
import 'package:isekai/data/usecase/session_use_case.dart';

final FutureProvider<List<Message>> currentThreadMessagesProvider =
    FutureProvider((ref) {
      return ref.watch(threadMessagesProvider(threadIdForDebug).future);
    });

final Provider<MessageActions> messageActionsProvider = Provider(
  (ref) => MessageActions(
    databaseActions: ref.watch(databaseActionsProvider),
    ref: ref,
  ),
);

class MessageActions {
  const MessageActions({
    required DatabaseActions databaseActions,
    required Ref ref,
  }) : _databaseActions = databaseActions,
       _ref = ref;

  final Ref _ref;
  final DatabaseActions _databaseActions;

  Future<void> sendMessage({required String text}) async {
    final session = await _ref.read(forceSessionProvider.future);
    final profile = _ref.read(profileProvider);
    const threadId = threadIdForDebug;

    await _databaseActions.sendMessage(
      userId: session.userId,
      threadId: threadId,
      userName: profile!.name,
      userIcon: profile.icon,
      text: text,
      createdAt: DateTime.now(),
    );
  }
}

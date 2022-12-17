import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/definitions/app_mode.dart';
import 'package:live_bresto/data/usecase/message_use_case.dart';
import 'package:live_bresto/ui/thread_presenter.dart';

final _threadPresenterProvider = Provider(
  (ref) => ThreadPresenter(messageActions: ref.watch(messageActionsProvider)),
);

class ThreadScreen extends ConsumerWidget {
  const ThreadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesStream = ref.watch(currentThreadMessagesProvider.stream);
    final presenter = ref.watch(_threadPresenterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context)!.appName} - ${AppMode.serverEnv.name}'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: messagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('エラーが発生しました。');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final messages = snapshot.data;
            if (messages == null) {
              return Container();
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                final message = messages[index];

                return ListTile(
                  title: Text(message.text),
                  subtitle: Text('User: ${message.userId}'),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemCount: messages.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => presenter.sendMessage(text: 'テスト🗣'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

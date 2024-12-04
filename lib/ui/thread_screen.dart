import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/thread.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/data/usecase/thread_use_case.dart';
import 'package:isekai/ui/settings_screen.dart';
import 'package:isekai/ui/thread_presenter.dart';

final _threadPresenterProvider = Provider(
  (ref) => ThreadPresenter(messageActions: ref.watch(messageActionsProvider)),
);

class ThreadScreen extends ConsumerWidget {
  const ThreadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.watch(_threadPresenterProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _TitleText(),
        actions: [
          _ProfileIconButton(
            onPressed: () {
              Navigator.push(
                context,
                SettingsScreen.route(),
              );
            },
          ),
        ],
      ),
      body: const MessagesPanel(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showProfileUpdateDialog(context, ref);

          var contributor = '';
          await showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                height: 750, // TODO(shimizu): サイズを比率にする。
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('閉じる'),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () {
                              presenter.sendMessage(text: contributor);
                              Navigator.pop(context);
                            },
                            child: const Text('投稿'),
                          ),
                        ),
                      ],
                    ),
                    Scrollbar(
                      child: TextField(
                        autofocus: true,
                        maxLines: 12,
                        minLines: 12,
                        decoration: const InputDecoration(
                          hintText: 'コメントを投稿する',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          contributor = text;
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'コメントを投稿する',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showProfileUpdateDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final preferenceActions = ref.read(preferenceActionsProvider);
    final hasShownDialog = await preferenceActions.loadFirstMessageFlag();

    if (hasShownDialog) {
      return;
    }

    var doNotShowAgain = true;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context)!.profileUpdateDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context)!.profileUpdateDialogContent),
              Row(
                children: [
                  Checkbox(
                    value: doNotShowAgain,
                    onChanged: (value) {
                      doNotShowAgain = value ?? true;
                    },
                  ),
                  Text(S.of(context)!.profileUpdateDialogDoNotShowAgain),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context)!.profileUpdateDialogOkButton),
            ),
          ],
        );
      },
    );

    if (doNotShowAgain) {
      await preferenceActions.saveFirstMessageFlag(value: true);
    }
  }
}

class _TitleText extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureThread = ref.watch(currentThreadProvider.future);

    return FutureBuilder<Thread>(
      future: futureThread,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('エラーが発生しました。');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final thread = snapshot.data;
        if (thread == null) {
          return const Text('null');
        }

        return Text(thread.title);
      },
    );
  }
}

class _ProfileIconButton extends ConsumerWidget {
  const _ProfileIconButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = ref.watch(profileProvider.select((profile) => profile?.icon));
    if (icon == null) {
      return const CircularProgressIndicator();
    }

    return IconButton(
      icon: Text(icon),
      onPressed: onPressed,
    );
  }
}

class MessagesPanel extends ConsumerWidget {
  const MessagesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureMessages = ref.watch(currentThreadMessagesProvider.future);

    return Column(
      children: [
        FutureBuilder(
          future: futureMessages,
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

            return Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final message = messages[index];

                  return ListTile(
                    title: Text(message.text),
                    subtitle: Text('User: ${message.userName}'),
                    trailing: Text(
                      S.of(context)!.messageDateFormat(
                            message.createdAt,
                            message.createdAt,
                          ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: messages.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

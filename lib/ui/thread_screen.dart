import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/model/thread.dart';
import 'package:isekai/data/repository/preference_repository.dart';
import 'package:isekai/data/usecase/message_use_case.dart';
import 'package:isekai/data/usecase/thread_use_case.dart';
import 'package:isekai/ui/post_message_screen.dart';
import 'package:isekai/ui/settings_screen.dart';

class ThreadScreen extends ConsumerStatefulWidget {
  const ThreadScreen({super.key});

  @override
  ConsumerState<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends ConsumerState<ThreadScreen> {
  @override
  Widget build(BuildContext context) {
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
        onPressed: () {
          Navigator.push(
            context,
            PostMessageScreen.route(),
          );
        },
        tooltip: 'コメントを投稿する',
        child: const Icon(Icons.add),
      ),
    );
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

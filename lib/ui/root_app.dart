import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/definitions/app_mode.dart';
import 'package:live_bresto/data/service/auth_service.dart';
import 'package:live_bresto/data/service/database_service.dart';
import 'package:live_bresto/ui/root_presenter.dart';

final _rootPresenterProvider = StateNotifierProvider<RootPresenter, bool>(
  (ref) => RootPresenter(ref: ref),
);

class RootApp extends ConsumerWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasInitialized = ref.watch(_rootPresenterProvider);
    if (!hasInitialized) {
      return Container();
    }

    return MaterialApp(
      title: 'Live Bresto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
      ],
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseActions = ref.watch(databaseActionsProvider);
    final threadMessagesStream =
        ref.watch(threadMessagesProvider(AppMode.threadIdForDebug).stream);

    return Scaffold(
      appBar: AppBar(
        title: Text('${S.of(context)!.appName} - ${AppMode.serverEnv.name}'),
      ),
      body: Center(
        child: StreamBuilder(
          stream: threadMessagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
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
        onPressed: () async {
          final session = await ref.read(sessionStreamProvider.future);
          await databaseActions.setMessage(
            threadId: AppMode.threadIdForDebug,
            text: 'テスト',
            userId: session.userId,
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

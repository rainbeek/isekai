import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/ui/root_presenter.dart';
import 'package:live_bresto/ui/thread_screen.dart';

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
      home: const ThreadScreen(),
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

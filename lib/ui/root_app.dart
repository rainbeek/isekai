import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_bresto/data/usecase/session_use_case.dart';
import 'package:live_bresto/ui/game/game_router.dart';
import 'package:live_bresto/ui/root_presenter.dart';

final _rootPresenterProvider = StateNotifierProvider<RootPresenter, bool>(
  (ref) => RootPresenter(sessionActions: ref.watch(sessionActionsProvider)),
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
      home: GameWidget(game: GameRouter()),
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

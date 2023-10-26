import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isekai/data/usecase/preference_use_case.dart';
import 'package:isekai/data/usecase/session_use_case.dart';
import 'package:isekai/ui/game/game_router.dart';
import 'package:isekai/ui/root_presenter.dart';
import 'package:isekai/ui/start_page.dart';
import 'package:isekai/ui/update_app_screen.dart';

final _rootPresenterProvider = StateNotifierProvider<RootPresenter, StartPage?>(
  (ref) => RootPresenter(
    sessionActions: ref.watch(sessionActionsProvider),
    preferenceActions: ref.watch(preferenceActionsProvider),
    ref: ref,
  ),
);

class RootApp extends ConsumerWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startPage = ref.watch(_rootPresenterProvider);
    if (startPage == null) {
      return Container();
    }

    final home = _generateHome(startPage: startPage);

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: home,
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

  Widget _generateHome({required StartPage startPage}) {
    switch (startPage) {
      case StartPage.updateApp:
        return const UpdateAppScreen();
      case StartPage.home:
        return GameWidget(game: GameRouter());
    }
  }
}

import 'dart:async';

import 'package:flame/game.dart';
import 'package:isekai/ui/game/field_home.dart';
import 'package:isekai/ui/game/game_init.dart';
import 'package:isekai/ui/thread_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRouter extends FlameGame {
  late final RouterComponent router;
  final Future<SharedPreferences> ref = SharedPreferences.getInstance();

  @override
  // 親クラスの仕様に従うため、FutureOr<void を返す
  // ignore: avoid_futureor_void
  FutureOr<void> onLoad() {
    add(
      router = RouterComponent(
        initialRoute: 'init',
        routes: {
          'init': Route(GameInit.new),
          'field_home': Route(FieldHome.new),
          'thread_screen': OverlayRoute(
            (context, game) => const ThreadScreen(),
          ),
        },
      ),
    );

    return super.onLoad();
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:isekai/ui/game/game_router.dart';

class GameInit extends Component with HasGameReference<GameRouter> {
  @override
  // 親クラスの仕様に従うため、FutureOr<void を返す
  // ignore: avoid_futureor_void
  FutureOr<void> onLoad() async {
    final ref = await game.ref;
    if (ref.getBool('isRegistered') ?? false) {
      game.router.pushNamed('field_home');
    }

    // TODO(takeda): 初期化処理
    await ref.setBool('isRegistered', true);
    game.router.pushNamed('field_home');
  }
}

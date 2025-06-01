import 'dart:async';

import 'package:flame/components.dart';
import 'package:isekai/ui/game/game_router.dart';
import 'package:isekai/ui/game/joystick.dart';
import 'package:isekai/ui/game/map.dart';
import 'package:isekai/ui/game/player.dart';
import 'package:isekai/ui/game/rock.dart';

class FieldHome extends Component
    with HasGameReference<GameRouter>, HasCollisionDetection {
  late final CameraComponent _cameraComponent;
  late final _player = Player();
  late final World _world;

  @override
  Future<void> onLoad() async {
    _world = World()..add(MapSprite());
    _world.add(_player);
    _cameraComponent = CameraComponent(world: _world);

    _world.add(Rock(Vector2(0, 0)));

    _cameraComponent.follow(_player);

    _cameraComponent.viewport.add(
      Joystick((direction) => _player.direction = direction),
    );

    await addWorldCollision(_world);

    await addAll([_world, _cameraComponent]);
  }

  Future<void> addWorldCollision(World world) async {
    final rectList = await readRayWorldCollisionMap();
    for (final rect in rectList) {
      world.add(
        WorldCollidable()
          ..position = Vector2(rect.left, rect.top)
          ..width = rect.width
          ..height = rect.height,
      );
    }
  }

  Player get player => _player;

  set player(Player p) {
    _player.direction = p.direction;
  }
}

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:live_bresto/ui/game/game_router.dart';
import 'package:live_bresto/ui/game/joystick.dart';
import 'package:live_bresto/ui/game/map.dart';
import 'package:live_bresto/ui/game/player.dart';
import 'package:live_bresto/ui/game/rock.dart';

class FieldHome extends Component
    with HasGameReference<GameRouter>, HasCollisionDetection {
  late final CameraComponent _cameraComponent;
  late final Player _player = Player();
  late final World _world;

  @override
  Future<void> onLoad() async {
    _world = World()..add(Map());
    _world.add(_player);
    _cameraComponent = CameraComponent(
      world: _world,
    );

    _world.add(Rock(Vector2(0, 0)));

    _cameraComponent.follow(_player);

    _cameraComponent.viewport.add(Joystick(onDirectionChanged));

    await addWorldCollision(_world);

    await addAll(
      [_world, _cameraComponent],
    );
  }

  Future<void> addWorldCollision(World world) async =>
      (await MapLoader.readRayWorldCollisionMap()).forEach((rect) {
        world.add(
          WorldCollidable()
            ..position = Vector2(rect.left, rect.top)
            ..width = rect.width
            ..height = rect.height,
        );
      });

  Player get player => _player;

  set player(Player p) {
    _player.direction = p.direction;
  }

  void onDirectionChanged(JoystickDirection d) {
    _player.direction = d;
  }

  @override
  void update(double delta) {
    super.update(delta);
  }
}

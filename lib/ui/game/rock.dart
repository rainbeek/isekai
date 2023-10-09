import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:isekai/ui/game/game_router.dart';

class Rock extends SpriteComponent
    with HasGameReference<GameRouter>, TapCallbacks {
  Rock(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(50),
          priority: 10,
        );

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('nine-box.png');
    paint = Paint()..color = const Color.fromARGB(255, 255, 7, 7);
    debugMode = true;
    add(RectangleHitbox());
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.router.pushNamed('thread_screen');
  }
}

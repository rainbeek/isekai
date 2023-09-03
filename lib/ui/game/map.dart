import 'dart:convert';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/services.dart';

class Map extends SpriteComponent with HasGameReference {
  @override
  Future<void>? onLoad() async {
    sprite = await game.loadSprite('map.png');
    size = sprite!.originalSize;

    return super.onLoad();
  }
}

class WorldCollidable extends PositionComponent {
  WorldCollidable() {
    add(RectangleHitbox());
  }
}

class MapLoader {
  static Future<List<Rect>> readRayWorldCollisionMap() async {
    final collidableRectangles = <Rect>[];
    final dynamic collisionMap = json.decode(
      await rootBundle.loadString('assets/tiles/map.json'),
    );

    for (final dynamic l in collisionMap['layers']) {
      final int height = collisionMap['height'];
      final int width = collisionMap['width'];
      l['data'].asMap().forEach((i, value) {
        if (value > 1) {
          collidableRectangles.add(
            Rect.fromLTWH(
              (i % width) * 32.0,
              (i / height) * 32.0,
              32,
              32,
            ),
          );
        }
      });
    }

    return collidableRectangles;
  }
}

import 'dart:convert';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/services.dart';
import 'package:isekai/data/model/world_map.dart';

class MapSprite extends SpriteComponent with HasGameReference {
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

Future<List<Rect>> readRayWorldCollisionMap() async {
  final collidableRectangles = <Rect>[];
  final collisionMapJson = json.decode(
    await rootBundle.loadString('assets/tiles/map.json'),
  );
  final collisionMap =
      WorldMap.fromJson(collisionMapJson as Map<String, dynamic>);

  for (final layer in collisionMap.layers) {
    layer.data.asMap().forEach((index, value) {
      if (value > 1) {
        collidableRectangles.add(
          Rect.fromLTWH(
            (index % collisionMap.width) * 32.0,
            (index ~/ collisionMap.height) *
                32.0, // Use integer division for accurate calculation
            32,
            32,
          ),
        );
      }
    });
  }

  return collidableRectangles;
}

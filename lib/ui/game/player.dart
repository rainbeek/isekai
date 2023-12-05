import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:isekai/ui/game/game_router.dart';
import 'package:isekai/ui/game/map.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference<GameRouter>, TapCallbacks, CollisionCallbacks {
  Player()
      : super(
          position: Vector2.all(200),
          size: Vector2.all(32),
          anchor: Anchor.center,
        );

  late TimerComponent bulletCreator;

  JoystickDirection direction = JoystickDirection.idle;
  JoystickDirection _collisionDirection = JoystickDirection.idle;
  final double _playerSpeed = 300;
  final double _animationSpeed = 0.15;

  double maxSpeed = 300;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;
    await _loadAnimations()
        .then((_) => {current = PlayerState.standingAnimation});

    add(
      bulletCreator = TimerComponent(
        period: 1,
        repeat: true,
        autoStart: false,
        // onTick: _createBullet,
      ),
    );

    add(RectangleHitbox());
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await game.images.load('player_sprite_sheet.png'),
      srcSize: Vector2(29, 32),
    );

    animations = {
      PlayerState.runDownAnimation:
          spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 4),
      PlayerState.runLeftAnimation:
          spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 4),
      PlayerState.runUpAnimation:
          spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 4),
      PlayerState.runRightAnimation:
          spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 4),
      PlayerState.standingAnimation:
          spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 1),
    };
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is WorldCollidable) {
      _collisionDirection = direction;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  void movePlayer(double delta) {
    switch (direction) {
      case JoystickDirection.up:
        if (canPlayerMoveUp()) {
          current = PlayerState.runUpAnimation;
          moveUp(delta);
        }
        break;
      case JoystickDirection.upLeft:
        if (canPlayerMoveUp() && canPlayerMoveLeft()) {
          current = PlayerState.runUpAnimation;
          moveUpLeft(delta);
        }
        break;
      case JoystickDirection.upRight:
        if (canPlayerMoveUp() && canPlayerMoveRight()) {
          current = PlayerState.runUpAnimation;
          moveUpRight(delta);
        }
        break;
      case JoystickDirection.down:
        if (canPlayerMoveDown()) {
          current = PlayerState.runDownAnimation;
          moveDown(delta);
        }
        break;
      case JoystickDirection.downLeft:
        if (canPlayerMoveDown() && canPlayerMoveLeft()) {
          current = PlayerState.runDownAnimation;
          moveDownLeft(delta);
        }
        break;
      case JoystickDirection.downRight:
        if (canPlayerMoveDown() && canPlayerMoveRight()) {
          current = PlayerState.runDownAnimation;
          moveDownRight(delta);
        }
        break;
      case JoystickDirection.left:
        if (canPlayerMoveLeft()) {
          current = PlayerState.runLeftAnimation;
          moveLeft(delta);
        }
        break;
      case JoystickDirection.right:
        if (canPlayerMoveRight()) {
          current = PlayerState.runRightAnimation;
          moveRight(delta);
        }
        break;
      case JoystickDirection.idle:
        break;
    }
  }

  bool canPlayerMoveUp() {
    if (isColliding &&
        (_collisionDirection == JoystickDirection.up ||
            _collisionDirection == JoystickDirection.upLeft ||
            _collisionDirection == JoystickDirection.upRight)) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (isColliding &&
        (_collisionDirection == JoystickDirection.down ||
            _collisionDirection == JoystickDirection.downLeft ||
            _collisionDirection == JoystickDirection.downRight)) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (isColliding &&
        (_collisionDirection == JoystickDirection.left ||
            _collisionDirection == JoystickDirection.upLeft ||
            _collisionDirection == JoystickDirection.downLeft)) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (isColliding &&
        (_collisionDirection == JoystickDirection.right ||
            _collisionDirection == JoystickDirection.upRight ||
            _collisionDirection == JoystickDirection.downRight)) {
      return false;
    }
    return true;
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -_playerSpeed));
  }

  void moveUpLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, delta * -_playerSpeed));
  }

  void moveUpRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, delta * -_playerSpeed));
  }

  void moveDown(double delta) {
    position.add(Vector2(0, delta * _playerSpeed));
  }

  void moveDownLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, delta * _playerSpeed));
  }

  void moveDownRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, delta * _playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -_playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * _playerSpeed, 0));
  }
}

enum PlayerState {
  runDownAnimation,
  runLeftAnimation,
  runUpAnimation,
  runRightAnimation,
  standingAnimation,
}

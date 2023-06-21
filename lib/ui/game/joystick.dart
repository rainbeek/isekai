import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Joystick extends JoystickComponent {
  Joystick(this.onDirectionChanged)
      : super(
          knob: CircleComponent(
            radius: 30,
            paint: BasicPalette.white.withAlpha(200).paint(),
          ),
          background: CircleComponent(
            radius: 100,
            paint: BasicPalette.white.withAlpha(100).paint(),
          ),
          margin: const EdgeInsets.only(left: 40, bottom: 40),
        );
  final ValueChanged<JoystickDirection> onDirectionChanged;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    onDirectionChanged(direction);
  }
}

import 'dart:math' as math;

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(game.widget);
}

class Bg extends Component with Resizable {
  static final _blue = Paint()..color = const Color(0xFF5B6EE1);

  @override
  void render(Canvas c) {
      c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), _blue);
  }

  @override
  void update(double t) {}
}

class Bird extends AnimationComponent with Resizable {
  static const SIZE = 32.0;
  static const GRAVITY = 13.0;
  static const BOOST = 320.0;

  bool frozen = true;
  double speedY;

  Bird(Size size) : super.sequenced(SIZE, SIZE, 'bird.png', 3, textureWidth: 8.0, textureHeight: 8.0);

  void reset() {
    frozen = true;
    speedY = 0.0;
    x = (size.width - SIZE) / 2;
    y = (size.height - SIZE) / 2;
  }

  @override
  void resize(Size size) {
    super.resize(size);
    this.reset();
  }

  @override
  void update(double t) {
    if (!frozen) {
      super.update(t);
      this.y += speedY * t - GRAVITY * t * t / 2;
      this.speedY += GRAVITY;
      this.angle = math.atan2(speedY, 500.0);
    }
  }

  void boost() {
    speedY = -BOOST;
  }

  void tap() {
    if (frozen) {
      frozen = false;
    } else if (y > size.height) {
      reset();
    } else {
      boost();
    }
  }
}

class MyGame extends BaseGame {
  Bird bird;

  MyGame(Size size) {
    add(Bg());
    add(bird = Bird(size));
  }

  @override
  void onTap() {
    bird?.tap();
  }
}
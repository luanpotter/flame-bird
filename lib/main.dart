import 'dart:math' as math;

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(game.widget);
}


class MyGame extends BaseGame {
  Bird bird;
  Bg background;

  MyGame(Size size) {
    add(background = Bg());
    add(bird = Bird(size));
  }

  @override
  void onTap() {
    bird?.tap();
  }
}

class Bg extends Component with Resizable {
  static final _brown = const Color(0xFFDDC0A3);

  Color color = Bg._brown;

  @override
  void render(Canvas c) {
      c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), bgColor);
  }

  get bgColor => Paint()..color = color;

  @override
  void update(double t) {}
}

class Bird extends AnimationComponent with Resizable {
  static const SIZE = 52.0;
  static const GRAVITY = 400.0;
  static const  BOOST = -380.0;

  bool frozen = true;
  double speedY;

  Bird(Size size) : super.sequenced(SIZE, SIZE, 'bird.png', 4, textureWidth: 16.0, textureHeight: 16.0) {
    anchor = Anchor.bottomCenter;
  }

  void reset() {
    frozen = true;
    x = size.width / 2;
    y = size.height / 2;
    speedY = 0.0;
    angle = velocity.angle();
  }

  @override
  void resize(Size size) {
    super.resize(size);
    this.reset();
  }

  Position get velocity => Position(200.0, speedY);

  @override
  void update(double t) {
    if (!frozen) {
      super.update(t);
      this.y += speedY * t - GRAVITY * t * t / 2;
      this.speedY += GRAVITY * t;
      this.angle = velocity.angle();

      if (y > size.height + 150) {
        this.reset();
      }
    }
  }

  void boost() {
    speedY = (speedY + BOOST).clamp(BOOST, speedY);
  }

  void tap() {
    if (frozen) {
      frozen = false;
    } else {
      boost();
    }
  }
}

import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
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

class Bird extends AnimationComponent {
  static const SIZE = 32.0;

  Bird(Size size) : super.sequenced(SIZE, SIZE, 'bird.png', 3, textureWidth: 8.0, textureHeight: 8.0) {
    this.x = (size.width - SIZE) / 2;
    this.y = (size.height - SIZE) / 2;
  }
}

class MyGame extends BaseGame {
  MyGame(Size size) {
    add(Bg());
    add(Bird(size));
  }
}
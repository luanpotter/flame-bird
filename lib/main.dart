import 'package:flame/components/animation_component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(game.widget);
}

class Bird extends AnimationComponent {
  static const SIZE = 32.0;

  Bird(Size size) : super.sequenced(SIZE, SIZE, 'bird.png', 3) {
    this.x = (size.width - SIZE) / 2;
    this.y = (size.height - SIZE) / 2;
  }
}

class MyGame extends BaseGame {
  MyGame(Size size) {
    add(Bird(size));
  }
}
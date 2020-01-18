
import 'package:flame/anchor.dart';
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
  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), Paint()..color = Color(0xFFFF00FF));
  }

  @override
  void update(double t) {}
}

class Bird extends AnimationComponent with Resizable {
  static const SIZE = 52.0;
  static const GRAVITY = 100.0;
  static const BOOST = 320.0;

  double speedY = 0.0;

  Bird() : super.sequenced(SIZE, SIZE, 'bird.png', 4, textureWidth: 16.0, textureHeight: 16.0) {
    this.anchor = Anchor.center;
  }

  @override
  void update(double t) {
    super.update(t);

    this.y += speedY * t - GRAVITY * t * t / 2;
    this.speedY += GRAVITY * t;
  }

  @override
  void resize(Size size) {
    super.resize(size);

    this.x = size.width / 2;
    this.y = size.height / 2;
    this.speedY = 0.0;
  }

  whenTap() {

  }
}

class MyGame extends BaseGame {

  final bird = Bird();

  MyGame(Size size) {
    this.size = size;
    add(Bg());
    add(bird);
  }

  @override
  void onTap() {
    bird.whenTap();
  }
}

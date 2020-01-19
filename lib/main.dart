import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/position.dart';
import 'package:flutter/material.dart';

const COLOR = const Color(0xFFDDC0A3);
const SIZE = 52.0;
const GRAVITY = 400.0;
const BOOST = -380.0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final size = await Flame.util.initialDimensions();

  final game = MyGame(size);
  runApp(game.widget);
}

class Bg extends Component with Resizable {
  final paint = Paint()..color = COLOR;

  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), paint);
  }

  @override
  void update(double t) {}
}

class Bird extends AnimationComponent with Resizable {
  double speedY = 0.0;
  bool freeze = true;
  Bird() : super.sequenced(SIZE, SIZE, 'bird.png', 4, textureWidth: 16.0, textureHeight: 16.0) {
    this.anchor = Anchor.center;
  }

  Position get velocity => Position(300, speedY);

  @override
  void resize(Size size) {
    super.resize(size);
    reset();
  }

  @override
  void update(double t) {
    if(freeze) return;
    super.update(t);

    if(y > size.height) {
      this.reset();
    }

    this.y += speedY * t - GRAVITY * t * t / 2;
    this.speedY += GRAVITY * t;
    this.angle = velocity.angle();
  }

  void reset() {
    this.x = size.width / 2;
    this.y = size.height / 2;
    this.speedY = 0.0;
    this.angle = 0.0;
    this.freeze = true;
  }

  void onTap() {
    if(freeze) {
      freeze = false;
      return;
    }

    speedY = (speedY + BOOST).clamp(BOOST, speedY);
  }
}

class MyGame extends BaseGame {
  Bird bird;
  MyGame(Size size) {
    add(Bg());
    add( bird = Bird() );
  }

  @override
  void onTap() {
    bird.onTap();
  }
}

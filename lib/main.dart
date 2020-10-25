import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/sprite_animation_component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.images.loadAll(['bird.png']);
  final gameSize = await Flame.util.initialDimensions();

  final game = MyGame(gameSize);
  runApp(game.widget);
}

class MyGame extends BaseGame with TapDetector {
  Bird bird;
  Bg background;

  MyGame(Vector2 gameSize) {
    add(background = Bg());
    add(bird = Bird(gameSize));
  }

  @override
  void onTap() {
    bird?.tap();
  }
}

class Bg extends Component with Resizable {
  static const _brown = const Color(0xFFDDC0A3);
  static final bgColor = Paint()..color = _brown;

  @override
  void render(Canvas c) {
    c.drawRect(gameSize.toRect(), bgColor);
  }
}

class Bird extends SpriteAnimationComponent with Resizable {
  static const GRAVITY = 400.0;
  static const BOOST = -380.0;

  bool frozen = true;
  double speedY;

  Bird(Vector2 gameSize)
      : super.sequenced(
          Vector2.all(52.0),
          Flame.images.fromCache('bird.png'),
          4,
          textureSize: Vector2.all(16.0),
        ) {
    anchor = Anchor.center;
  }

  void reset() {
    frozen = true;
    position = gameSize / 2;
    speedY = 0.0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    reset();
  }

  Vector2 get velocity => Vector2(200.0, speedY);

  @override
  double get angle => -velocity.angleToSigned(Vector2(1, 0));

  @override
  void update(double t) {
    if (!frozen) {
      super.update(t);
      y += speedY * t - GRAVITY * t * t / 2;
      speedY += GRAVITY * t;

      if (y > gameSize.y + 150) {
        reset();
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

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
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

class MyGame extends BaseGame {

  MyGame(Size size) {
    // TODO: initialize game here
  }
}

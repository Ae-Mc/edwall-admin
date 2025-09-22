import 'package:flutter/material.dart';

final hostBaseUrl = Uri.parse("https://rustaveli.ae-mc.ru");
const settingsKey = "SETTINGS_KEY";
const minHoldImageId = 1;
const maxHoldImageId = 100;
const holdColors = [
  Color(0xFFFFFFFF),
  Color(0xFFFF0000),
  Color(0xFF00FF00),
  Color(0xFF0000FF),
  Color(0xFFFFFF00),
];

final colorToColorNumber = {
  Color(0xFF000000): 0,
  Color(0xFFFFFFFF): 1,
  Color(0xFF00FF00): 2,
  Color(0xFF0000FF): 3,
  Color(0xFFFF0000): 4,
  Color(0xFFFFFF00): 5,
};

const Map<int, Color> holdTypeToColor = {
  0: Color(0xFF000000),
  1: Color(0xFFFFFFFF),
  2: Color(0xFF00FF00),
  3: Color(0xFF0000FF),
  4: Color(0xFFFF0000),
  5: Color(0xFFFFFF00),
};

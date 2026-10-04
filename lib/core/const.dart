import 'package:flutter/services.dart';

class AppConfig {
  const AppConfig({
    required this.name,
    required this.logoText,
    required this.hostBaseUrl,
  });

  final String name;
  final String logoText;
  final String hostBaseUrl;
}

const appConfigs = {
  'edwall': AppConfig(
    name: 'Edwall Admin',
    logoText: 'EDWALL',
    hostBaseUrl: 'https://edwall.ae-mc.ru',
  ),
  'rustaveli': AppConfig(
    name: 'Rustaveli Admin',
    logoText: 'RUSTAVELI',
    hostBaseUrl: 'https://rustaveli.ae-mc.ru',
  ),
};

const defaultAppFlavor = 'edwall';
final appConfig = appConfigs[appFlavor] ?? appConfigs[defaultAppFlavor]!;
final hostBaseUrl = Uri.parse(appConfig.hostBaseUrl);
const settingsKey = "SETTINGS_KEY";
const minHoldImageId = 1;
const maxHoldImageId = 100;
const holdColors = [
  Color(0xFFFFFFFF),
  Color(0xFF00FF00),
  Color(0xFF0000FF),
  Color(0xFFFF0000),
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

final colorToLEColorNumber = {
  Color(0xFF000000): 0,
  Color(0xFFFF0000): 1,
  Color(0xFF00FF00): 2,
  Color(0xFF0000FF): 3,
  Color(0xFFFFFF00): 4,
  Color(0xFFFF00FF): 5,
  Color(0xFF00FFFF): 6,
  Color(0xFFFFFFFF): 7,
};

const Map<int, Color> holdTypeToColor = {
  0: Color(0xFF000000),
  1: Color(0xFFFFFFFF),
  2: Color(0xFF00FF00),
  3: Color(0xFF0000FF),
  4: Color(0xFFFF0000),
  5: Color(0xFFFFFF00),
};

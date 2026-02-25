import 'package:edwall_admin/app/theme/models/pallete.dart';
import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';
part 'theme_model.tailor.dart';

@TailorMixin(themeGetter: ThemeGetter.onBuildContext)
class ThemeModel extends ThemeExtension<ThemeModel>
    with _$ThemeModelTailorMixin {
  @override
  final Brightness brightness;
  @override
  final MaterialColor completed;
  @override
  final MaterialColor primary;
  @override
  final MaterialColor secondary;
  @override
  final MaterialColor outline;
  @override
  final MaterialColor onSuccess;
  @override
  final MaterialColor success;
  @override
  final MaterialColor loginIcon;
  @override
  final MaterialColor disabledColor;
  @override
  final MaterialColor loginIconBackground;
  @override
  final Color background;
  @override
  final Color card;
  @override
  final String fontFamily;
  @override
  final TextTheme textTheme;

  ThemeModel({
    required this.brightness,
    required this.background,
    required this.completed,
    required this.disabledColor,
    required this.primary,
    required this.secondary,
    required this.outline,
    required this.card,
    MaterialColor? onSuccess,
    MaterialColor? success,
    MaterialColor? loginIcon,
    MaterialColor? loginIconBackground,
    this.textTheme = const TextTheme(
      bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 20),
      titleLarge: TextStyle(fontSize: 36),
      titleMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontSize: 24),
      headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
      headlineSmall: TextStyle(fontSize: 32),
    ),
    this.fontFamily = "Alumni Sans",
  }) : success = success ?? Pallete.lightGreen.material,
       onSuccess = onSuccess ?? Pallete.black.material,
       loginIcon = loginIcon ?? Pallete.gigas.material,
       loginIconBackground = loginIconBackground ?? Pallete.blueChalk.material;
}

extension ColorsExt on Color {
  MaterialColor get material {
    final int red = r.clamp(0, 255).round();
    final int green = g.clamp(0, 255).round();
    final int blue = b.clamp(0, 255).round();

    final Map<int, Color> shades = {
      50: Color.fromRGBO(red, green, blue, .1),
      100: Color.fromRGBO(red, green, blue, .2),
      200: Color.fromRGBO(red, green, blue, .3),
      300: Color.fromRGBO(red, green, blue, .4),
      400: Color.fromRGBO(red, green, blue, .5),
      500: Color.fromRGBO(red, green, blue, .6),
      600: Color.fromRGBO(red, green, blue, .7),
      700: Color.fromRGBO(red, green, blue, .8),
      800: Color.fromRGBO(red, green, blue, .9),
      900: Color.fromRGBO(red, green, blue, 1),
    };

    return MaterialColor(toARGB32(), shades);
  }
}

import 'dart:ui';

import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/app/theme/models/pallete.dart';

final lightTheme = ThemeModel(
  background: Pallete.orchidWhite,
  brightness: Brightness.light,
  completed: Pallete.reef.material,
  disabledColor: Pallete.grey.material,
  outline: Pallete.grey.material,
  primary: Pallete.spicyPink.material,
  secondary: Pallete.black.material,
);

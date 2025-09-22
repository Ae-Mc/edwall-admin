import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/app/theme/models/pallete.dart';
import 'package:flutter/material.dart';

final darkTheme = ThemeModel(
  background: Pallete.dark,
  brightness: Brightness.dark,
  completed: Pallete.reef.material,
  disabledColor: Pallete.grey.material,
  outline: Pallete.grey.material,
  primary: Pallete.orange.material,
  secondary: Pallete.orchidWhite.material,
);

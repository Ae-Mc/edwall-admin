import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/app/theme/models/dark_theme.dart';
import 'package:edwall_admin/app/theme/models/light_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'theme.g.dart';

@riverpod
class Theme extends _$Theme {
  @override
  ThemeModel build() {
    return lightTheme;
  }

  void setDarkTheme() {
    state = darkTheme;
  }

  void setLightTheme() {
    state = lightTheme;
  }

  void switchTheme() {
    switch (state) {
      case _ when state == lightTheme:
        state = darkTheme;
      case _ when state == darkTheme:
        state = lightTheme;
    }
  }
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_model.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$ThemeModelTailorMixin on ThemeExtension<ThemeModel> {
  Brightness get brightness;
  MaterialColor get completed;
  MaterialColor get primary;
  MaterialColor get secondary;
  MaterialColor get outline;
  MaterialColor get onSuccess;
  MaterialColor get success;
  MaterialColor get loginIcon;
  MaterialColor get disabledColor;
  MaterialColor get loginIconBackground;
  Color get background;
  Color get card;
  String get fontFamily;
  TextTheme get textTheme;

  @override
  ThemeModel copyWith({
    Brightness? brightness,
    MaterialColor? completed,
    MaterialColor? primary,
    MaterialColor? secondary,
    MaterialColor? outline,
    MaterialColor? onSuccess,
    MaterialColor? success,
    MaterialColor? loginIcon,
    MaterialColor? disabledColor,
    MaterialColor? loginIconBackground,
    Color? background,
    Color? card,
    String? fontFamily,
    TextTheme? textTheme,
  }) {
    return ThemeModel(
      brightness: brightness ?? this.brightness,
      completed: completed ?? this.completed,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      outline: outline ?? this.outline,
      onSuccess: onSuccess ?? this.onSuccess,
      success: success ?? this.success,
      loginIcon: loginIcon ?? this.loginIcon,
      disabledColor: disabledColor ?? this.disabledColor,
      loginIconBackground: loginIconBackground ?? this.loginIconBackground,
      background: background ?? this.background,
      card: card ?? this.card,
      fontFamily: fontFamily ?? this.fontFamily,
      textTheme: textTheme ?? this.textTheme,
    );
  }

  @override
  ThemeModel lerp(covariant ThemeExtension<ThemeModel>? other, double t) {
    if (other is! ThemeModel) return this as ThemeModel;
    return ThemeModel(
      brightness: t < 0.5 ? brightness : other.brightness,
      completed: t < 0.5 ? completed : other.completed,
      primary: t < 0.5 ? primary : other.primary,
      secondary: t < 0.5 ? secondary : other.secondary,
      outline: t < 0.5 ? outline : other.outline,
      onSuccess: t < 0.5 ? onSuccess : other.onSuccess,
      success: t < 0.5 ? success : other.success,
      loginIcon: t < 0.5 ? loginIcon : other.loginIcon,
      disabledColor: t < 0.5 ? disabledColor : other.disabledColor,
      loginIconBackground: t < 0.5
          ? loginIconBackground
          : other.loginIconBackground,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      fontFamily: t < 0.5 ? fontFamily : other.fontFamily,
      textTheme: t < 0.5 ? textTheme : other.textTheme,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThemeModel &&
            const DeepCollectionEquality().equals(
              brightness,
              other.brightness,
            ) &&
            const DeepCollectionEquality().equals(completed, other.completed) &&
            const DeepCollectionEquality().equals(primary, other.primary) &&
            const DeepCollectionEquality().equals(secondary, other.secondary) &&
            const DeepCollectionEquality().equals(outline, other.outline) &&
            const DeepCollectionEquality().equals(onSuccess, other.onSuccess) &&
            const DeepCollectionEquality().equals(success, other.success) &&
            const DeepCollectionEquality().equals(loginIcon, other.loginIcon) &&
            const DeepCollectionEquality().equals(
              disabledColor,
              other.disabledColor,
            ) &&
            const DeepCollectionEquality().equals(
              loginIconBackground,
              other.loginIconBackground,
            ) &&
            const DeepCollectionEquality().equals(
              background,
              other.background,
            ) &&
            const DeepCollectionEquality().equals(card, other.card) &&
            const DeepCollectionEquality().equals(
              fontFamily,
              other.fontFamily,
            ) &&
            const DeepCollectionEquality().equals(textTheme, other.textTheme));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(brightness),
      const DeepCollectionEquality().hash(completed),
      const DeepCollectionEquality().hash(primary),
      const DeepCollectionEquality().hash(secondary),
      const DeepCollectionEquality().hash(outline),
      const DeepCollectionEquality().hash(onSuccess),
      const DeepCollectionEquality().hash(success),
      const DeepCollectionEquality().hash(loginIcon),
      const DeepCollectionEquality().hash(disabledColor),
      const DeepCollectionEquality().hash(loginIconBackground),
      const DeepCollectionEquality().hash(background),
      const DeepCollectionEquality().hash(card),
      const DeepCollectionEquality().hash(fontFamily),
      const DeepCollectionEquality().hash(textTheme),
    );
  }
}

extension ThemeModelBuildContext on BuildContext {
  ThemeModel get themeModel => Theme.of(this).extension<ThemeModel>()!;
}

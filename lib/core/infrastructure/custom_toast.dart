import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class CustomToast {
  final BuildContext context;

  CustomToast(this.context);

  static void showTextFailureToastStatic(String text, ThemeData theme) {
    final colorTheme = theme.colorScheme;

    _showToast(
      primaryColor: colorTheme.error,
      onPrimaryColor: colorTheme.onError,
      icon: Icon(Icons.info_outline, color: colorTheme.onError),
      style: ToastificationStyle.fillColored,
      title: 'Ошибка!',
      description: text,
    );
  }

  void showTextFailureToast(String text) {
    showTextFailureToastStatic(text, Theme.of(context));
  }

  static void showTextSuccessToastStatic(String text, ThemeData theme) {
    _showToast(
      primaryColor: theme.extension<ThemeModel>()!.success,
      onPrimaryColor: theme.extension<ThemeModel>()!.onSuccess,
      icon: Icon(Icons.done, color: theme.colorScheme.primary),
      style: ToastificationStyle.fillColored,
      description: text,
    );
  }

  void showTextSuccessToast(String text) {
    showTextSuccessToastStatic(text, Theme.of(context));
  }

  static void _showToast({
    String? description,
    String? title,
    EdgeInsets padding = const Pad(horizontal: 16, vertical: 8),
    ToastificationStyle style = ToastificationStyle.fillColored,
    required Widget icon,
    required Color primaryColor,
    required Color onPrimaryColor,
  }) {
    toastification.show(
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: primaryColor,
      icon: icon,
      padding: padding,
      style: style,
      title: title == null
          ? null
          : Text(title, style: TextStyle(color: onPrimaryColor)),
      description: description == null
          ? null
          : Text(description, style: TextStyle(color: onPrimaryColor)),
    );
  }
}

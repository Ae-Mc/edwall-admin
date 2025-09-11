import 'package:edwall_admin/core/widgets/base_future_button.dart';
import 'package:flutter/material.dart';

class FutureOutlinedButton extends BaseFutureButton {
  const FutureOutlinedButton({
    super.key,
    super.onPressed,
    required super.child,
    super.indicatorColor,
    super.buttonStyle,
  });

  @override
  buttonConstructor({required child, onPressed, style}) =>
      OutlinedButton(onPressed: onPressed, style: style, child: child);
}

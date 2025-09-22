import 'package:edwall_admin/core/widgets/base_future_button.dart';
import 'package:flutter/material.dart';

class FutureButton extends BaseFutureButton {
  const FutureButton({
    super.key,
    super.onPressed,
    required super.child,
    super.indicatorColor,
    super.buttonStyle,
  });

  @override
  buttonConstructor({required child, onPressed, style}) =>
      ElevatedButton(onPressed: onPressed, style: style, child: child);
}

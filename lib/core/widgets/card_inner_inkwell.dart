import 'package:flutter/material.dart';

class CardInnerInkwell extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final Widget child;

  const CardInnerInkwell({
    super.key,
    this.onTap,
    this.onDoubleTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final shape = Theme.of(context).cardTheme.shape;
    final radius = switch (shape) {
      RoundedRectangleBorder() => shape.borderRadius.resolve(null),
      _ => BorderRadius.circular(Theme.of(context).useMaterial3 ? 12 : 4),
    };
    return InkWell(
      borderRadius: radius,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: child,
    );
  }
}

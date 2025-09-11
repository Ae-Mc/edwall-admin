import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class BaseFutureButton extends HookWidget {
  final Future<void> Function()? onPressed;
  final Widget child;
  final Color? indicatorColor;
  final ButtonStyle? buttonStyle;

  const BaseFutureButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.indicatorColor,
    this.buttonStyle,
  });

  ButtonStyleButton buttonConstructor({
    ButtonStyle? style,
    Future<void> Function()? onPressed,
    required Widget child,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final theme = Theme.of(context);

    return buttonConstructor(
      style: buttonStyle,
      onPressed: onPressed == null
          ? null
          : isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              try {
                await onPressed?.call();
              } on ExceptionWithMessage catch (e) {
                CustomToast.showTextFailureToastStatic(e.message, theme);
              } finally {
                isLoading.value = false;
              }
            },
      child: isLoading.value
          ? CircularProgressIndicator(
              color: indicatorColor ?? theme.colorScheme.onPrimary,
            )
          : child,
    );
  }
}

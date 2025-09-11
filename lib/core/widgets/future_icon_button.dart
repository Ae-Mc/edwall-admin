import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FutureIconButton extends HookWidget {
  final Future<void> Function() onPressed;
  final Widget icon;
  final Color? indicatorColor;

  final ButtonStyle? buttonStyle;

  const FutureIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.indicatorColor,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final theme = Theme.of(context);

    return IconButton(
      style: buttonStyle,
      onPressed: isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              try {
                await onPressed();
              } on ExceptionWithMessage catch (e) {
                CustomToast.showTextFailureToastStatic(e.message, theme);
              } finally {
                isLoading.value = false;
              }
            },
      icon: isLoading.value
          ? SizedBox.square(
              dimension: 48,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                heightFactor: 0.8,
                child: CircularProgressIndicator(
                  color: indicatorColor ?? theme.colorScheme.primary,
                ),
              ),
            )
          : icon,
    );
  }
}

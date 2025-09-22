import 'dart:async';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomCheckbox extends HookWidget {
  final bool isCompleted;
  final Future Function() onPressed;
  final Color? iconColor;

  const CustomCheckbox({
    super.key,
    required this.isCompleted,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final futureState = useState<Future?>(null);
    final future = useFuture(futureState.value);

    if (future.connectionState == ConnectionState.waiting) {
      return SizedBox.square(
        dimension: 40,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.8,
          child: CircularProgressIndicator(color: iconColor),
        ),
      );
    }

    return OutlinedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(Pad(all: 8)),
        minimumSize: WidgetStatePropertyAll(Size.zero),
        side: WidgetStatePropertyAll(
          BorderSide(color: iconColor ?? theme.colorScheme.tertiary),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () => futureState.value = onPressed().onError(
        (error, stackTrace) =>
            CustomToast.showTextFailureToastStatic(error.toString(), theme),
      ),
      child: isCompleted
          ? Icon(
              Icons.done,
              color: iconColor ?? theme.colorScheme.tertiary,
              size: 24,
            )
          : Box(width: 24, height: 24),
    );
  }
}

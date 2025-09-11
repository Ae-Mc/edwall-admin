import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:flutter/material.dart';

class ErrorColumn extends StatelessWidget {
  final Object error;
  final Function() onRetry;

  const ErrorColumn({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ErrorText(error: error),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: const Text("Повторить попытку")),
      ],
    );
  }
}

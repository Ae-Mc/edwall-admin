import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationDialog extends ConsumerWidget {
  final String title;
  final String content;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(title),
      content: Text(content, style: textTheme.headlineSmall),
      actions: [
        TextButton(
          onPressed: () => context.router.pop(true),
          child: Text('Да'),
        ),
        TextButton(
          onPressed: () => context.router.pop(false),
          child: Text('Отмена'),
        ),
      ],
    );
  }
}

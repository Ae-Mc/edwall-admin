import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final Object error;

  const ErrorText({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error.toString(),
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

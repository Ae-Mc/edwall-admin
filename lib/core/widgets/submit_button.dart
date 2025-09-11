import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final void Function()? onPressed;
  final String text;

  const SubmitButton(
      {super.key,
      required this.snapshot,
      required this.onPressed,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: snapshot.connectionState == ConnectionState.waiting
          ? () {}
          : onPressed,
      child: snapshot.connectionState == ConnectionState.waiting
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2),
            )
          : Text(text),
    );
  }
}

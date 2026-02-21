import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  const SquareButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(Pad.zero),
        minimumSize: WidgetStatePropertyAll(Size.zero),
        shape: WidgetStatePropertyAll(ContinuousRectangleBorder()),
        side: WidgetStatePropertyAll(
          BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
      ),
      child: Icon(icon, size: 40),
    );
  }
}

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

class RowNumberCell extends StatelessWidget {
  final int number;
  final double size;

  const RowNumberCell({super.key, required this.number, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Pad(right: size * 0.2),
      height: size,
      constraints: BoxConstraints(minWidth: size),
      child: Text(
        number.toString(),
        textAlign: TextAlign.right,
      ),
    );
  }
}

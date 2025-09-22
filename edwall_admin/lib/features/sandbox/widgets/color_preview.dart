import 'package:edwall_admin/core/const.dart';
import 'package:flutter/material.dart';

class ColorPreview extends StatelessWidget {
  final int colorCode;
  final double size;

  const ColorPreview({super.key, required this.colorCode, required this.size});

  @override
  Widget build(BuildContext context) {
    final color = holdTypeToColor[colorCode]!;

    return SizedBox.square(
      dimension: size,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            color: color,
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

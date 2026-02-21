import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class OutlinedBackButton extends StatelessWidget {
  const OutlinedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(Pad(all: 12)),
          minimumSize: WidgetStatePropertyAll(Size.zero),
          fixedSize: WidgetStatePropertyAll(Size(45, 45)),
        ),
        onPressed: () => context.router.pop(),
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

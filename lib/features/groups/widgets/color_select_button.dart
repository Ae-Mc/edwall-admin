import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/features/sandbox/domain/hold_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorSelectButton extends ConsumerWidget {
  final String name;
  final Color color;

  const ColorSelectButton({super.key, required this.name, required this.color});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorNumber = colorToColorNumber[color]!;
    return Consumer(
      builder: (context, ref, child) => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            color.withAlpha(
              (colorNumber == ref.watch(holdColorProvider)) ? 224 : 96,
            ),
          ),
        ),
        onPressed: () => ref.read(holdColorProvider.notifier).set(colorNumber),
        child: Center(child: Text(name)),
      ),
    );
  }
}

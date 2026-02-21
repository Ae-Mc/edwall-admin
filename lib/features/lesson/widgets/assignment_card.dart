import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';

class AssignmentCard extends HookWidget {
  final Route route;
  final void Function() onClimbTap;
  final void Function()? onAddTap;

  const AssignmentCard({
    super.key,
    required this.route,
    required this.onClimbTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final expanded = useState(false);
    final theme = Theme.of(context);
    var shape =
        Theme.of(context).cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    if (shape is RoundedRectangleBorder && expanded.value) {
      shape = shape.copyWith(
        side: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Card(
      shape: shape,
      child: CardInnerInkwell(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: Pad(
            top: 4,
            bottom: expanded.value ? 12 : 4,
            left: 8,
            right: expanded.value ? 16 : 4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Заголовок задания
              Text(
                route.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              // Описание (только в развёрнутом виде)
              if (expanded.value) ...[
                const Box.gap(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        route.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                    const Box.gap(16),
                    // Кнопки
                    OutlinedButton(
                      onPressed: onClimbTap,
                      child: const Text("На скалодром"),
                    ),
                    const Box.gap(16),
                    ElevatedButton(
                      onPressed: onAddTap,
                      child: const Text("Добавить"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

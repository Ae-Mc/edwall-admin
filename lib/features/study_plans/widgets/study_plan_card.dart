import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StudyPlanCard extends HookWidget {
  final StudyPlan studyPlan;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onEdit;
  final Future<void> Function() onSelect;

  const StudyPlanCard({
    super.key,
    this.onDelete,
    this.onEdit,
    required this.onSelect,
    required this.studyPlan,
  });

  @override
  Widget build(BuildContext context) {
    final expanded = useState(false);
    late final Color borderColor;
    if (expanded.value) {
      borderColor = Theme.of(context).colorScheme.primary;
    } else {
      borderColor = Theme.of(context).colorScheme.outline;
    }
    final cardShape =
        Theme.of(context).cardTheme.shape as RoundedRectangleBorder;

    return Card(
      shape: cardShape.copyWith(side: BorderSide(color: borderColor)),
      child: CardInnerInkwell(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: const Pad(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                studyPlan.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (expanded.value) ...[
                Box.gap(8),
                Text(
                  studyPlan.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Box.gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onDelete != null) ...[
                      FutureButton(onPressed: onDelete, child: Text("Удалить")),
                      Box.gap(8),
                    ],
                    if (onEdit != null) ...[
                      FutureButton(
                        onPressed: onEdit,
                        child: Text("Редактировать"),
                      ),
                      Box.gap(8),
                    ],
                    FutureButton(onPressed: onSelect, child: Text("Выбрать")),
                  ],
                ),
              ] else ...[
                // Box.gap(8),
                // Text(
                //   studyPlan.description,
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //     color: Theme.of(context).colorScheme.secondary,
                //   ),
                // ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

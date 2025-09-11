import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StudyPlanCard extends StatelessWidget {
  final StudyPlan studyPlan;
  final void Function() onSelect;

  const StudyPlanCard({
    super.key,
    required this.studyPlan,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return HookBuilder(
      builder: (context) {
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
                  Box.gap(8),
                  if (expanded.value) ...[
                    Text(
                      studyPlan.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Box.gap(8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: onSelect,
                        child: Text("Выбрать"),
                      ),
                    ),
                  ] else ...[
                    Text(
                      studyPlan.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

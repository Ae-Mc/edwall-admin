import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LessonCard extends HookWidget {
  final Lesson lesson;

  const LessonCard({super.key, required this.lesson});

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
                lesson.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (expanded.value) ...[
                Box.gap(8),
                Text(
                  lesson.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Box.gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FutureButton(
                      onPressed: () async => await context.router.push(
                        LessonRoute(lessonId: lesson.id),
                      ),
                      child: Text("Редактировать"),
                    ),
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

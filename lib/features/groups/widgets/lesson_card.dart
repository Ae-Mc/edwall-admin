import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/groups/domain/completed_lessons.dart';
import 'package:edwall_admin/features/groups/domain/selected_lesson.dart';
import 'package:edwall_admin/features/groups/widgets/custom_checkbox.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonCard extends HookWidget {
  final Lesson lesson;
  final bool completed;
  final int index;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.completed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expanded = useState(false);
    late final Color borderColor;

    if (expanded.value) {
      borderColor = theme.colorScheme.primary;
    } else {
      borderColor = theme.colorScheme.outline;
    }
    final cardShape =
        Theme.of(context).cardTheme.shape as RoundedRectangleBorder;

    return Card(
      shape: cardShape.copyWith(side: BorderSide(color: borderColor)),
      color: completed ? theme.extension<ThemeModel>()!.completed : null,
      child: CardInnerInkwell(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: Pad(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Box.gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "$index. ${lesson.name}",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    if (expanded.value)
                      Padding(
                        padding: Pad(left: 24),
                        child: Text(
                          lesson.description,
                          style: TextStyle(color: theme.colorScheme.tertiary),
                        ),
                      ),
                  ],
                ),
              ),
              if (expanded.value) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: Pad(right: 48),
                      child: Consumer(
                        builder: (context, ref, child) => Row(
                          children: [
                            Text(
                              'УРОК ПРОЙДЕН',
                              style: theme.textTheme.titleSmall,
                            ),
                            SizedBox(width: 16),
                            CustomCheckbox(
                              isCompleted: completed,
                              onPressed: () async {
                                final provider = ref.read(
                                  completedLessonsProvider.notifier,
                                );
                                if (completed) {
                                  await provider.makeLessonIncomplete(
                                    lesson.id,
                                  );
                                } else {
                                  await provider.completeLesson(lesson.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Box.gap(16),
                    Padding(
                      padding: Pad(right: 24),
                      child: Consumer(
                        builder: (context, ref, child) => FutureButton(
                          onPressed: () async {
                            await ref
                                .read(selectedLessonProvider.notifier)
                                .loadLesson(lesson.id);

                            if (context.mounted) {
                              context.pushRoute(
                                WorkingLessonRoute(lesson: lesson),
                              );
                            }
                          },
                          child: Text("К УРОКУ"),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                if (completed)
                  Padding(
                    padding: Pad(right: 56, vertical: 8),
                    child: Icon(Icons.done, color: theme.colorScheme.tertiary),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

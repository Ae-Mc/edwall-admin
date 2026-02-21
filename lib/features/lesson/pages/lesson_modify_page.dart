import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/core/widgets/outlined_back_button.dart';
import 'package:edwall_admin/features/groups/domain/lesson.dart';
import 'package:edwall_admin/features/lesson/widgets/route_card.dart';
import 'package:edwall_admin/features/lessons/domain/lessons.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LessonModifyPage extends HookConsumerWidget {
  final int? lessonId;
  final int? newLessonOrder;

  const LessonModifyPage({this.newLessonOrder, super.key, this.lessonId})
    : assert(newLessonOrder != null || lessonId != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyPlan = ref.watch(activeStudyPlanProvider)!;
    final insecure = useState(false);
    final theme = Theme.of(context);
    late final AsyncValue<LessonRead?> lesson;
    late final LessonProvider? lessonProv;

    if (lessonId == null) {
      lessonProv = null;
      lesson = AsyncValue.data(null);
    } else {
      lessonProv = lessonProvider(lessonId!);
      lesson = ref.watch(lessonProv);
    }

    return lesson.when(
      data: (initial) => HookBuilder(
        builder: (context) {
          final name = useTextEditingController(text: initial?.name ?? '');
          final description = useTextEditingController(
            text: initial?.description ?? '',
          );
          final routes = useState<List<Route>>(initial?.routes ?? []);

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const Pad(left: 30, top: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            OutlinedBackButton(),
                            Box.gap(16),
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Учебный план: ${studyPlan.name}',
                                    ),
                                    if (initial != null)
                                      TextSpan(text: '\nУрок: ${initial.name}'),
                                  ],
                                ),
                                style: theme.textTheme.titleLarge,
                              ),
                            ),
                            CurrentTimeWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: Pad(top: 8, left: 32, right: 48),
                  sliver: SliverList.list(
                    children: [
                      Text(
                        'Название урока',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Box.gap(16),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(hintText: 'Название урока'),
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      ),
                      Box.gap(16),
                      Text(
                        'Описание',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Box.gap(16),
                      TextField(
                        controller: description,
                        decoration: InputDecoration(hintText: 'Описание урока'),
                        maxLines: 5,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      Box.gap(32),
                      Text(
                        'Список заданий',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Box.gap(16),
                      ...[
                        for (final route in routes.value.indexed) ...[
                          RouteCard(
                            route: route.$2,
                            onDownTap: () =>
                                routes.value = List.from(routes.value)
                                  ..removeAt(route.$1)
                                  ..insert(
                                    min(route.$1 + 1, routes.value.length - 1),
                                    route.$2,
                                  ),
                            onUpTap: () =>
                                routes.value = List.from(routes.value)
                                  ..removeAt(route.$1)
                                  ..insert(max(route.$1 - 1, 0), route.$2),
                            onDeleteTap: () {
                              routes.value = List.from(routes.value)
                                ..remove(route.$2);
                            },
                          ),
                          Box.gap(16),
                        ],
                        Center(
                          child: ElevatedButton(
                            onPressed: () => context.router
                                .push(
                                  RouteSelectRoute(
                                    excludeIds: routes.value
                                        .map((e) => e.id)
                                        .toList(),
                                  ),
                                )
                                .then((value) {
                                  if (value != null && value is Route) {
                                    routes.value = List.from(routes.value)
                                      ..add(value);
                                  }
                                }),
                            child: const Text('Добавить задание'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: Pad(right: 48, left: 32, vertical: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (initial != null) ...[
                          Card(
                            child: Padding(
                              padding: const Pad(
                                top: 8,
                                horizontal: 12,
                                bottom: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'ПОДТВЕРДИТЕ ДЕЙСТВИЕ',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                  Box.gap(16),
                                  SizedBox(
                                    width: 128,
                                    child:
                                        (insecure.value
                                        ? FutureButton.new
                                        : OutlinedButton.new)(
                                          onPressed: insecure.value
                                              ? () async {
                                                  await ref
                                                      .read(
                                                        lessonsProvider
                                                            .notifier,
                                                      )
                                                      .delete(initial.id);
                                                  if (context.mounted) {
                                                    context.router
                                                        .popUntilRouteWithName(
                                                          LessonsRoute.name,
                                                        );
                                                  }
                                                }
                                              : null,
                                          child: Text('УДАЛИТЬ'),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Box.gap(16),
                          IconButton(
                            onPressed: () => insecure.value = !insecure.value,
                            icon: Icon(
                              insecure.value
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                            ),
                            iconSize: 48,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                        Expanded(child: Box()),
                        FutureButton(
                          onPressed: () async {
                            final lessons = ref.read(lessonsProvider.notifier);
                            if (initial != null) {
                              await lessons.modify(
                                initial.id,
                                LessonUpdate(
                                  description: description.text,
                                  name: name.text,
                                ),
                                routes.value.map((e) => e.id).toList(),
                              );
                            } else if (newLessonOrder != null) {
                              await lessons.add(
                                LessonBaseExtended(
                                  description: description.text,
                                  name: name.text,
                                  order: newLessonOrder!,
                                  studyPlanId: studyPlan.id,
                                  originProgrammeId: null,
                                ),
                                routes.value.map((e) => e.id).toList(),
                              );
                            } else {
                              throw StateError("Impossible state");
                            }
                            if (context.mounted) {
                              context.router.pop();
                            }
                          },
                          buttonStyle: ButtonStyle(
                            textStyle: WidgetStatePropertyAll(
                              Theme.of(
                                context,
                              ).textTheme.headlineMedium?.apply(color: null),
                            ),
                            padding: WidgetStatePropertyAll(
                              Pad(horizontal: 24, vertical: 16),
                            ),
                          ),
                          child: Text('СОХРАНИТЬ ИЗМЕНЕНИЯ'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ошибка загрузки данных урока'),
            ElevatedButton(
              onPressed: () =>
                  (lessonProv == null) ? null : ref.invalidate(lessonProv),
              child: Text("Повторить попытку"),
            ),
          ],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

import 'dart:async';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/features/groups/domain/completed_lessons.dart';
import 'package:edwall_admin/features/groups/domain/completed_routes.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:edwall_admin/features/groups/domain/selected_lesson.dart';
import 'package:edwall_admin/features/groups/domain/selected_route.dart';
import 'package:edwall_admin/features/groups/domain/study_groups.dart';
import 'package:edwall_admin/features/groups/domain/study_plan.dart';
import 'package:edwall_admin/features/groups/widgets/group_card.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class GroupSelectPage extends StatelessWidget {
  const GroupSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () =>
            AutoRouter.of(context).push(GroupModifyRoute(initialGroup: null)),
        icon: Icon(Icons.add_circle_outline),
        color: theme.colorScheme.primary,
        iconSize: 48,
      ),
      body: Column(
        children: [
          Stack(
            fit: StackFit.passthrough,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text("ВЫБОР ГРУППЫ"),
              ),
              Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
            ],
          ),
          Expanded(
            child: HookConsumer(
              builder: (context, ref, child) {
                final groups = ref.watch(myStudyGroupsProvider);
                final selectedIndex = useState(-1);

                return groups.when(
                  data: (data) {
                    data.sort((a, b) => a.name.compareTo(b.name));
                    return RefreshIndicator.adaptive(
                      onRefresh: () => onRefresh(ref),
                      child: ListView.separated(
                        padding: Pad(left: 32, right: 48, top: 8),
                        itemCount: data.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemBuilder: (context, index) => GroupCard(
                          group: data[index],
                          selected: index == selectedIndex.value,
                          onTap: () async => selectedIndex.value =
                              index == selectedIndex.value ? -1 : index,
                          onPlanSelect: () async {
                            ref
                                .read(selectedGroupProvider.notifier)
                                .setGroup(data[index]);
                            AutoRouter.of(context).push(WorkingGroupRoute());
                          },
                          onContinueSelect: () async =>
                              await onContinueSelect(ref, data[index]),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => RefreshIndicator.adaptive(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              "Ошибка: $error",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onRefresh: () => onRefresh(ref),
                  ),
                  loading: () =>
                      Center(child: CircularProgressIndicator.adaptive()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onContinueSelect(WidgetRef ref, StudyGroupRead group) async {
    ref.read(selectedGroupProvider.notifier).setGroup(group);
    final plan = await ref.read(studyPlanProvider(group.studyPlanId).future);
    final completedLessons = await ref.read(completedLessonsProvider.future);
    Lesson? selectedLesson;
    for (final element in plan.lessons) {
      if (!completedLessons.contains(element.id)) {
        selectedLesson = element;
        break;
      }
    }

    final routesToPush = <PageRouteInfo>[WorkingGroupRoute()];

    if (selectedLesson != null) {
      routesToPush.add(WorkingLessonRoute(lesson: selectedLesson));
      LessonRead? fullLesson = await ref
          .read(selectedLessonProvider.notifier)
          .loadLesson(selectedLesson.id);
      final completedRoutes = await ref.read(completedRoutesProvider.future);
      Route? selectedRoute;
      for (final element in fullLesson.routes) {
        if (!completedRoutes.contains(element.id)) {
          selectedRoute = element;
          break;
        }
      }
      if (selectedRoute != null) {
        await ref
            .read(selectedRouteProvider.notifier)
            .loadRoute(selectedRoute.id);
        routesToPush.add(WorkingRouteRoute());
      }
    }

    if (ref.context.mounted) {
      await AutoRouter.of(ref.context).pushAll(routesToPush);
    }
  }

  Future<void> onRefresh(WidgetRef ref) async {
    ref.invalidate(myStudyGroupsProvider);
    await ref.read(myStudyGroupsProvider.future);
  }
}

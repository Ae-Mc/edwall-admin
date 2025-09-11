import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/features/groups/domain/completed_routes.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:edwall_admin/features/groups/domain/selected_lesson.dart';
import 'package:edwall_admin/features/groups/domain/selected_route.dart';
import 'package:edwall_admin/features/groups/widgets/color_select_button.dart';
import 'package:edwall_admin/features/groups/widgets/custom_checkbox.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:edwall_admin/core/widgets/future_icon_button.dart';
import 'package:edwall_admin/features/sandbox/widgets/active_wall_widget.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WorkingRoutePage extends StatelessWidget {
  const WorkingRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.maybePop(),
        label: Text("К СПИСКУ ЗАДАНИЙ"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final selectedGroup = ref.read(selectedGroupProvider);
          final theme = Theme.of(context);
          final lesson = ref.watch(selectedLessonProvider)!;
          final route = ref.watch(selectedRouteProvider)!;
          final settings = ref.watch(settingsProvider).requireValue;
          if (selectedGroup == null) {
            return const ErrorText(
              error: 'Impossible state: No group selected',
            );
          }
          final wall = ref.watch(wallProvider(settings.wallId));
          final error = wall.error;
          final isLoading = wall.isLoading;
          final currentRouteIndex = lesson.routes.indexWhere(
            (element) => element.id == route.id,
          );

          if (isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (error != null) {
            return ErrorColumn(
              error: error,
              onRetry: () => ref.invalidate(wallProvider(settings.wallId)),
            );
          }

          return wall.when(
            data: (wall) => Stack(
              children: [
                Positioned.fill(
                  top: 32,
                  left: 32,
                  right: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "ГРУППА: ${selectedGroup.name}\n"
                              "Учебный план: ${selectedGroup.studyPlan.name}",
                              style: theme.textTheme.headlineLarge,
                            ),
                          ),
                          // Box.gap(16),
                          // TextbookButton(),
                          // Box.gap(12),
                          // BookmarkButton(),
                          // Box.gap(12),
                          // InfoButton(),
                          // Box.gap(16),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 56,
                              child: Theme(
                                data: theme.copyWith(
                                  colorScheme: theme.colorScheme.copyWith(
                                    primary: theme.colorScheme.onPrimary,
                                  ),
                                  iconButtonTheme: IconButtonThemeData(
                                    style: IconButton.styleFrom(
                                      foregroundColor:
                                          theme.colorScheme.onPrimary,
                                      padding: Pad.zero,
                                      visualDensity: VisualDensity.compact,
                                      iconSize: 48,
                                    ),
                                  ),
                                  elevatedButtonTheme: ElevatedButtonThemeData(
                                    style: ElevatedButton.styleFrom(
                                      iconSize: 40,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      padding: Pad.zero,
                                      minimumSize: Size.zero,
                                      fixedSize: const Size(48, 48),
                                    ),
                                  ),
                                  textTheme: theme.textTheme.apply(
                                    bodyColor: theme.colorScheme.onPrimary,
                                    displayColor: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                child: Builder(
                                  builder: (context) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (currentRouteIndex > 0)
                                        FutureIconButton(
                                          onPressed: () => changeRoute(
                                            ref,
                                            wall,
                                            lesson,
                                            currentRouteIndex - 1,
                                          ),
                                          icon: Icon(
                                            Icons.arrow_circle_left_outlined,
                                          ),
                                        )
                                      else
                                        SizedBox.square(dimension: 48),
                                      Expanded(
                                        child: Text(
                                          "${lesson.name}. Задание: ${route.name}",
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (currentRouteIndex <
                                          lesson.routes.length - 1)
                                        FutureIconButton(
                                          onPressed: () => changeRoute(
                                            ref,
                                            wall,
                                            lesson,
                                            currentRouteIndex + 1,
                                          ),
                                          icon: Icon(
                                            Icons.arrow_circle_right_outlined,
                                          ),
                                        )
                                      else
                                        SizedBox.square(dimension: 48),
                                      Box.gap(32),
                                      HookConsumer(
                                        builder: (context, ref, child) {
                                          final completedRoutes = ref.watch(
                                            completedRoutesProvider,
                                          );
                                          final isLoading =
                                              completedRoutes.isLoading;

                                          if (isLoading) {
                                            return SizedBox.square(
                                              dimension: 40,
                                              child:
                                                  const CircularProgressIndicator(),
                                            );
                                          }

                                          if (completedRoutes.hasError) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback(
                                                  (timeStamp) =>
                                                      CustomToast(
                                                        context,
                                                      ).showTextFailureToast(
                                                        completedRoutes.error
                                                            .toString(),
                                                      ),
                                                );
                                            return IconButton.filled(
                                              iconSize: 40,
                                              style: ButtonStyle(
                                                elevation:
                                                    WidgetStatePropertyAll(8),
                                              ),
                                              onPressed: () => ref.invalidate(
                                                completedRoutesProvider,
                                              ),
                                              icon: Icon(
                                                Icons.refresh,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            );
                                          }

                                          final isRouteCompleted =
                                              completedRoutes.requireValue
                                                  .contains(route.id);

                                          return CustomCheckbox(
                                            isCompleted: isRouteCompleted,
                                            iconColor:
                                                theme.colorScheme.onPrimary,
                                            onPressed: () => completeRoute(
                                              ref,
                                              isRouteCompleted,
                                            ),
                                          );
                                        },
                                      ),
                                      Box.gap(8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Box.gap(16),
                            Card(
                              child: Padding(
                                padding: const Pad(all: 12),
                                child: Text(route.description, maxLines: 7),
                              ),
                            ),
                            Box.gap(16),
                            SizedBox(
                              height: 300,
                              child: ActiveWallWidget(
                                wall: wall,
                                editable: true,
                              ),
                            ),
                            Box.gap(16),
                            Row(
                              children: [
                                ...holdColors.indexed.map(
                                  (e) => Padding(
                                    padding: Pad(right: 16),
                                    child: ColorSelectButton(
                                      color: e.$2,
                                      name: [
                                        'РУКА',
                                        "НОГА",
                                        "СТАРТ",
                                        "ФИНИШ",
                                        "ДОП",
                                      ][e.$1],
                                    ),
                                  ),
                                ),
                                Box.gap(32),
                                OutlinedButton(
                                  style: ButtonStyle(
                                    minimumSize: WidgetStatePropertyAll(
                                      Size(0, 40),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final notifier = ref.read(
                                      wallStateProvider(0, 0).notifier,
                                    );
                                    notifier.clear(wall);
                                    await notifier.showRoute(route, 0);
                                  },
                                  child: Text("ВЕРНУТЬ К ИСХОДНОМУ"),
                                ),
                              ],
                            ),
                            Box.gap(16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
              ],
            ),
            error: (error, stackTrace) => ErrorColumn(
              error: error,
              onRetry: () => ref.invalidate(wallProvider(settings.wallId)),
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          );
        },
      ),
    );
  }

  Future<void> changeRoute(
    WidgetRef ref,
    WallRead wall,
    LessonRead lesson,
    int newIndex,
  ) async {
    final route = await ref
        .read(selectedRouteProvider.notifier)
        .loadRoute(lesson.routes[newIndex].id);
    final notifier = ref.read(wallStateProvider(0, 0).notifier);
    notifier.clear(wall);
    await notifier.showRoute(route, 0);
  }

  Future<void> completeRoute(WidgetRef ref, bool isRouteCompleted) async {
    final notifier = ref.read(completedRoutesProvider.notifier);
    late final Future<void> future;
    final route = ref.watch(selectedRouteProvider)!;
    if (isRouteCompleted) {
      future = notifier.makeRouteIncomplete(route.id);
    } else {
      future = notifier.completeRoute(route.id);
    }
    await future.onError(
      (error, stackTrace) => ref.context.mounted
          ? CustomToast(ref.context).showTextFailureToast(error.toString())
          : null,
    );
  }
}

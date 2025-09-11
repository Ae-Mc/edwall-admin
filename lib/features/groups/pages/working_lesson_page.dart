import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/features/groups/domain/completed_routes.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:edwall_admin/features/groups/domain/selected_lesson.dart';
import 'package:edwall_admin/features/groups/widgets/bookmark_button.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:edwall_admin/features/groups/widgets/info_button.dart';
import 'package:edwall_admin/features/groups/widgets/route_card.dart';
import 'package:edwall_admin/features/groups/widgets/textbook_button.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class WorkingLessonPage extends StatelessWidget {
  final Lesson lesson;
  const WorkingLessonPage({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.maybePop(),
        label: Text("К СПИСКУ УРОКОВ"),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final selectedGroup = ref.read(selectedGroupProvider);
          if (selectedGroup == null) {
            throw StateError('Impossible state: No group selected');
          }
          final theme = Theme.of(context);

          return Stack(
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
                            "Учебный план: ${selectedGroup.studyPlan.name}\n"
                            "Урок: ${lesson.name}",
                            style: theme.textTheme.headlineLarge,
                          ),
                        ),
                        Box.gap(16),
                        TextbookButton(),
                        Box.gap(12),
                        BookmarkButton(),
                        Box.gap(12),
                        InfoButton(),
                      ],
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final completedRoutes = ref.watch(
                            completedRoutesProvider,
                          );
                          final fullLesson = ref.watch(selectedLessonProvider);
                          final isLoading =
                              (fullLesson == null ||
                              (!completedRoutes.hasValue &&
                                  completedRoutes.isLoading));

                          if (isLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            );
                          }

                          if (completedRoutes.error != null) {
                            return ErrorColumn(
                              error: completedRoutes.error!,
                              onRetry: () =>
                                  ref.invalidate(completedRoutesProvider),
                            );
                          }

                          return ListView.builder(
                            padding: const Pad(bottom: 80),
                            itemCount: fullLesson.routes.length,
                            itemBuilder: (context, index) => Card(
                              child: RouteCard(
                                route: fullLesson.routes[index],
                                index: index + 1,
                                completed: completedRoutes.requireValue
                                    .contains(fullLesson.routes[index].id),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
            ],
          );
        },
      ),
    );
  }
}

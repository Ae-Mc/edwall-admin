import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/features/groups/domain/completed_lessons.dart';
import 'package:edwall_admin/features/groups/domain/selected_group.dart';
import 'package:edwall_admin/features/groups/domain/study_plan.dart';
import 'package:edwall_admin/features/groups/widgets/bookmark_button.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:edwall_admin/features/groups/widgets/info_button.dart';
import 'package:edwall_admin/features/groups/widgets/lesson_card.dart';
import 'package:edwall_admin/features/groups/widgets/textbook_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class WorkingGroupPage extends StatelessWidget {
  const WorkingGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.replaceRoute(GroupSelectRoute()),
        label: Text("К ВЫБОРУ ГРУППЫ"),
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
                child: Padding(
                  padding: const Pad(top: 32, horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "ГРУППА: ${selectedGroup.name}\n"
                              "Учебный план: ${selectedGroup.studyPlan.name}\n",
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
                            final completedLessons = ref.watch(
                              completedLessonsProvider,
                            );
                            final selectedGroup = ref.read(
                              selectedGroupProvider,
                            )!;
                            final studyPlan = ref.watch(
                              studyPlanProvider(selectedGroup.studyPlan.id),
                            );
                            final error =
                                completedLessons.error ?? studyPlan.error;
                            final isLoading =
                                completedLessons.valueOrNull == null ||
                                studyPlan.isLoading;

                            if (isLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: theme.colorScheme.primary,
                                ),
                              );
                            }
                            if (error != null) {
                              return ErrorColumn(
                                error: error,
                                onRetry: () {
                                  ref.invalidate(completedLessonsProvider);
                                  ref.invalidate(
                                    studyPlanProvider(
                                      selectedGroup.studyPlan.id,
                                    ),
                                  );
                                },
                              );
                            }

                            return ListView.builder(
                              padding: const Pad(bottom: 80),
                              itemCount: studyPlan.requireValue.lessons.length,
                              itemBuilder: (context, index) => LessonCard(
                                index: index + 1,
                                lesson: studyPlan.requireValue.lessons[index],
                                completed: completedLessons.requireValue
                                    .contains(
                                      studyPlan.requireValue.lessons[index].id,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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

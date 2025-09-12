import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:edwall_admin/features/study_plans/domain/study_plans.dart';
import 'package:edwall_admin/features/study_plans/widgets/study_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class StudyPlansPage extends ConsumerWidget {
  const StudyPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyPlans = ref.watch(studyPlansProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Учебные планы")),
      body: studyPlans.when(
        data: (studyPlans) => ListView.separated(
          padding: const Pad(all: 16),
          itemCount: studyPlans.length + 1,
          separatorBuilder: (context, index) => Box.gap(16),
          itemBuilder: (context, index) {
            if (index == studyPlans.length) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.router.push(StudyPlanModifyRoute()),
                  child: Text("Добавить учебный план"),
                ),
              );
            }
            final studyPlan = studyPlans[index];

            return StudyPlanCard(
              studyPlan: studyPlan,
              onEdit: () async {
                context.router.push(StudyPlanModifyRoute(initial: studyPlan));
              },
              onSelect: () async {
                ref
                    .read(activeStudyPlanProvider.notifier)
                    .setStudyPlan(studyPlan);
              },
            );
          },
        ),
        error: (error, stackTrace) =>
            Center(child: Text("Ошибка загрузки учебных планов")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

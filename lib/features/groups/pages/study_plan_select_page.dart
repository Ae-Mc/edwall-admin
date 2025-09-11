import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/features/groups/domain/study_plans.dart';
import 'package:edwall_admin/features/groups/widgets/study_plan_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class StudyPlanSelectPage extends HookWidget {
  const StudyPlanSelectPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Consumer(
      builder: (context, ref, child) {
        final studyPlans = ref.watch(studyPlansProvider);
        return studyPlans.when(
          data: (data) => ListView.separated(
            padding: const Pad(horizontal: 16, vertical: 16),
            itemBuilder: (context, index) => StudyPlanCard(
              onSelect: () {
                context.maybePop(data[index]);
              },
              studyPlan: data[index],
            ),
            separatorBuilder: (context, index) => Box.gap(8),
            itemCount: data.length,
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ошибка: $error"),
                IconButton.filled(
                  onPressed: () => ref.invalidate(studyPlansProvider),
                  icon: Icon(Icons.refresh),
                ),
              ],
            ),
          ),
          loading: () => Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    ),
  );
}

import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/features/lessons/domain/lessons.dart';
import 'package:edwall_admin/features/lessons/widgets/lesson_card.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:flutter/material.dart' hide BottomSheet;
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class LessonsPage extends HookConsumerWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = lessonsProvider;
    final activeStudyPlan = ref.watch(activeStudyPlanProvider);
    final lessons = ref.watch(provider);
    final textTheme = Theme.of(context).textTheme;

    if (activeStudyPlan == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Сначала выберите учебный план!",
            style: textTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => const [
              SliverAppBar(title: Text("Уроки")),
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(provider);
                await ref.read(provider.future);
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const Pad(all: 16),
                    sliver: lessons.when(
                      data: (lessons) => lessons.isEmpty
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  "Уроки не найдены",
                                  style: textTheme.labelLarge,
                                ),
                              ),
                            )
                          : SliverList.separated(
                              itemBuilder: (context, index) =>
                                  LessonCard(lesson: lessons[index]),
                              itemCount: lessons.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                            ),
                      error: (error, _) =>
                          SliverToBoxAdapter(child: ErrorText(error: error)),
                      loading: () => const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  ),
                  lessons.maybeWhen(
                    orElse: () => SliverToBoxAdapter(),
                    data: (lessons) => SliverPadding(
                      padding: const Pad(bottom: 16),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => context.router.push(
                              LessonModifyRoute(
                                newLessonOrder:
                                    lessons.map((e) => e.order).fold(0, max) +
                                    1,
                              ),
                            ),
                            child: const Text("Добавить урок"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

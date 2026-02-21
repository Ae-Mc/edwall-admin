import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/outlined_back_button.dart';
import 'package:edwall_admin/features/lesson/widgets/assignment_card.dart';
import 'package:edwall_admin/features/routes/domain/routes.dart';
import 'package:edwall_admin/features/programmes/domain/programmes.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:edwall_admin/features/study_plans/domain/active_study_plan.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class NewRouteSelectPage extends HookConsumerWidget {
  final List<int> excludeIds;

  const NewRouteSelectPage({super.key, this.excludeIds = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final studyPlan = ref.watch(activeStudyPlanProvider)!;

    // Состояние выбранной программы (id) и раздела учебника
    final selectedProgrammeId = useState<int?>(null);

    // Загружаем список программ (без маршрутов) и при выборе — полную программу с маршрутами
    final programmesAsync = ref.watch(programmesProvider());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Шапка (идентична lesson_modify_page.dart)
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
                              TextSpan(text: 'Учебный план: ${studyPlan.name}'),
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
          // Селектор раздела учебника
          SliverPadding(
            padding: Pad(top: 8, left: 32, right: 48),
            sliver: SliverList.list(
              children: [
                Text('Раздел учебника', style: theme.textTheme.labelMedium),
                const Box.gap(16),
                // Селектор программы
                programmesAsync.when(
                  data: (programmes) => DropdownButton<int?>(
                    value: selectedProgrammeId.value,
                    hint: const Text('Выберите программу'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Все трассы'),
                      ),
                      ...programmes.map(
                        (p) => DropdownMenuItem<int?>(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      ),
                    ],
                    onChanged: (v) => selectedProgrammeId.value = v,
                  ),
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  error: (e, _) => Text('Ошибка загрузки программ: $e'),
                ),
                const Box.gap(16),
                // Список заданий
                Text('Список заданий', style: theme.textTheme.labelMedium),
                const Box.gap(16),
                // Список заданий — либо все трассы, либо трассы из выбранной программы
                if (selectedProgrammeId.value == null) ...[
                  for (final route
                      in ref
                          .watch(routesProvider())
                          .maybeWhen(data: (data) => data, orElse: () => []))
                    AssignmentCard(
                      route: route,
                      onClimbTap: () {
                        // Пока ничего не делает
                        print('Кнопка "На скалодром" нажата');
                      },
                      onAddTap: excludeIds.contains(route.id)
                          ? null
                          : () {
                              // Закрываем страницу и возвращаем выбранное задание
                              context.router.pop(route);
                            },
                    ),
                ] else
                  // Загружаем полную программу с её маршрутами
                  ...ref
                      .watch(programmeProvider(selectedProgrammeId.value!))
                      .maybeWhen(
                        data: (programmeRead) => [
                          for (final route in programmeRead.routes)
                            AssignmentCard(
                              route: route,
                              onClimbTap: () {},
                              onAddTap: excludeIds.contains(route.id)
                                  ? null
                                  : () => context.router.pop(route),
                            ),
                        ],
                        orElse: () => [
                          const Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

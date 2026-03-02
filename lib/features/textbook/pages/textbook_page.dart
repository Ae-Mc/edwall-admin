import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/default_app_bar.dart';
import 'package:edwall_admin/features/lesson/widgets/assignment_card.dart';
import 'package:edwall_admin/features/programmes/domain/programmes.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class TextbookPage extends HookConsumerWidget {
  const TextbookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Состояние выбранной программы (id) и раздела учебника
    final selectedProgrammeId = useState<int?>(null);

    // Загружаем список программ (без маршрутов) и при выборе — полную программу с маршрутами
    final programmesAsync = ref.watch(programmesProvider());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: DefaultAppBar(title: Text('Учебник'))),
          SliverPadding(
            padding: Pad(top: 8, left: 32, right: 48),
            sliver: SliverList.list(
              children: [
                Text('Раздел учебника', style: theme.textTheme.labelMedium),
                const Box.gap(16),
                programmesAsync.when(
                  data: (programmes) {
                    if (selectedProgrammeId.value != null &&
                        !programmes.any(
                          (p) => p.id == selectedProgrammeId.value,
                        )) {
                      // Если выбранный раздел был удален, сбрасываем выбор
                      selectedProgrammeId.value = null;
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: DropdownButton<int?>(
                            value: selectedProgrammeId.value,
                            hint: const Text('Выберите раздел'),
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem<int?>(
                                value: null,
                                child: Text('Не выбран'),
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
                        ),
                        if (selectedProgrammeId.value != null) ...[
                          const Box.gap(16),
                          OutlinedButton(
                            onPressed: () => context.router.push(
                              ProgrammeModifyRoute(
                                programmeId: selectedProgrammeId.value!,
                              ),
                            ),
                            child: Text("Изменить раздел"),
                          ),
                        ],
                        const Box.gap(16),
                        ElevatedButton(
                          onPressed: () =>
                              context.router.push(ProgrammeModifyRoute()),
                          child: Text("Добавить раздел"),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                  error: (e, _) => Text('Ошибка загрузки программ: $e'),
                ),
                const Box.gap(16),
                Text('Список заданий', style: theme.textTheme.labelMedium),
                const Box.gap(16),
                if (selectedProgrammeId.value == null)
                  Center(
                    child: Text(
                      'Выберите раздел учебника, чтобы увидеть его задания.',
                      style: theme.textTheme.headlineMedium,
                    ),
                  )
                else
                  // Загружаем полную программу с её маршрутами
                  ...ref
                      .watch(programmeProvider(selectedProgrammeId.value!))
                      .maybeWhen(
                        data: (programmeRead) => [
                          for (final route in programmeRead.routes)
                            AssignmentCard(
                              route: route,
                              onClimbTap: () => context.router.push(
                                RouteModifyRoute(
                                  routeId: route.id,
                                  programmeId: programmeRead.id,
                                ),
                              ),
                              showAddButton: false,
                              onAddTap: null,
                            ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => context.router.push(
                                RouteModifyRoute(programmeId: programmeRead.id),
                              ),
                              child: Text("Добавить задание"),
                            ),
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

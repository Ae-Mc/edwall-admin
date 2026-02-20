import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/core/widgets/current_time_widget.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/study_plans/domain/study_plans.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class StudyPlanModifyPage extends HookConsumerWidget {
  final StudyPlan? initial;

  const StudyPlanModifyPage({super.key, this.initial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = useTextEditingController(text: initial?.name ?? '');
    final description = useTextEditingController(
      text: initial?.description ?? '',
    );
    final insecure = useState(false);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                AppBar(
                  title: Text('ДАННЫЕ ОБ УЧЕБНОМ ПЛАНЕ'),
                  titleSpacing: 30,
                ),
                Positioned(top: 4, right: 12, child: CurrentTimeWidget()),
              ],
            ),
          ),
          SliverPadding(
            padding: Pad(top: 8, left: 32, right: 48),
            sliver: SliverList.list(
              children: [
                Text(
                  'Название учебного плана',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Box.gap(16),
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: 'Название учебного плана',
                  ),
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
                  decoration: InputDecoration(
                    hintText: 'Описание учебного плана',
                  ),
                  maxLines: 5,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
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
                        padding: const Pad(top: 8, horizontal: 12, bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'ПОДТВЕРДИТЕ ДЕЙСТВИЕ',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Box.gap(16),
                            SizedBox(
                              width: 190,
                              child:
                                  (insecure.value
                                  ? FutureButton.new
                                  : OutlinedButton.new)(
                                    onPressed: insecure.value
                                        ? () async {
                                            await ref
                                                .read(
                                                  studyPlansProvider.notifier,
                                                )
                                                .delete(initial!.id);
                                            if (context.mounted) {
                                              context.router
                                                  .popUntilRouteWithName(
                                                    StudyPlansRoute.name,
                                                  );
                                            }
                                          }
                                        : null,
                                    child: Text('УДАЛИТЬ УЧЕБНЫЙ ПЛАН'),
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
                      final studyPlans = ref.read(studyPlansProvider.notifier);
                      if (initial != null) {
                        await studyPlans.modify(
                          initial!.id,
                          StudyPlanUpdate(
                            description: description.text,
                            name: name.text,
                          ),
                        );
                      } else {
                        await studyPlans.add(
                          StudyPlanBase(
                            description: description.text,
                            name: name.text,
                          ),
                        );
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
  }
}

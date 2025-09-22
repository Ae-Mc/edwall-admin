import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/app/router/app_router.dart';
import 'package:edwall_admin/app/theme/models/theme_model.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/card_inner_inkwell.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/features/groups/domain/completed_routes.dart';
import 'package:edwall_admin/features/groups/domain/selected_route.dart';
import 'package:edwall_admin/features/groups/widgets/custom_checkbox.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteCard extends HookWidget {
  final Route route;
  final bool completed;
  final int index;

  const RouteCard({
    super.key,
    required this.route,
    required this.completed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expanded = useState(false);
    late final Color borderColor;

    if (expanded.value) {
      borderColor = theme.colorScheme.primary;
    } else {
      borderColor = theme.colorScheme.outline;
    }
    final cardShape =
        Theme.of(context).cardTheme.shape as RoundedRectangleBorder;

    return Card(
      shape: cardShape.copyWith(side: BorderSide(color: borderColor)),
      color: completed ? theme.extension<ThemeModel>()!.completed : null,
      child: CardInnerInkwell(
        onTap: () => expanded.value = !expanded.value,
        child: Padding(
          padding: Pad(vertical: 4),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Box.gap(8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "$index. ${route.name}${route.hardnessId == null ? '' : ' ${'*' * ((route.hardnessId as int) - 1)}'}",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      if (expanded.value)
                        Padding(
                          padding: Pad(left: 24),
                          child: Text(
                            route.description,
                            style: TextStyle(color: theme.colorScheme.tertiary),
                          ),
                        ),
                    ],
                  ),
                ),
                if (expanded.value) ...[
                  SizedBox(
                    height: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: Pad(right: 48),
                          child: Consumer(
                            builder: (context, ref, child) => Row(
                              children: [
                                Text(
                                  'ЗАДАНИЕ ПРОЙДЕНО',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(width: 16),
                                CustomCheckbox(
                                  isCompleted: completed,
                                  onPressed: () async {
                                    final provider = ref.read(
                                      completedRoutesProvider.notifier,
                                    );
                                    if (completed) {
                                      await provider.makeRouteIncomplete(
                                        route.id,
                                      );
                                    } else {
                                      await provider.completeRoute(route.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Box.gap(16),
                        Padding(
                          padding: Pad(right: 24),
                          child: Consumer(
                            builder: (context, ref, child) {
                              return FutureButton(
                                onPressed: () => showRoute(ref),
                                child: Text("НА СКАЛОДРОМ"),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  if (completed)
                    Padding(
                      padding: Pad(right: 56, vertical: 8),
                      child: Icon(
                        Icons.done,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showRoute(WidgetRef ref) async {
    try {
      await ref.read(selectedRouteProvider.notifier).loadRoute(route.id);
      final selectedRoute = ref.read(selectedRouteProvider);

      final settings = await ref.read(settingsProvider.future);
      final wall = await ref.read(wallProvider(settings.wallId).future);
      final wallState = ref.read(wallStateProvider(0, 0).notifier);
      wallState.clear(wall);
      await wallState.showRoute(selectedRoute!, 0);

      if (ref.context.mounted) {
        ref.context.pushRoute(WorkingRouteRoute());
      }
    } on ExceptionWithMessage catch (e) {
      if (ref.context.mounted) {
        CustomToast(ref.context).showTextFailureToast(e.message);
      }
    }
  }
}

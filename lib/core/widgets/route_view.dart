import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/providers/route.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/core/widgets/future_button.dart';
import 'package:edwall_admin/core/widgets/route_widget.dart';
import 'package:edwall_admin/features/routes/widgets/route_on_wall_preview.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteView extends ConsumerWidget {
  final Route route;

  final Future<void> Function()? onDeletePressed;

  const RouteView(this.route, {this.onDeletePressed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeRead = ref.watch(routeProvider(route.id));
    final settings = ref.watch(settingsProvider);
    final editDialog = AlertDialog(
      title: const Text("Справка"),
      content: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text:
                  "Для редактирования задания нажмите кнопку 'Применить', затем на экране песочницы нажмите кнопку сохранить ",
            ),
            WidgetSpan(
              child: Icon(
                Icons.save,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            TextSpan(text: " в правом верхнем углу."),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.router.pop(),
          child: const Text("Закрыть"),
        ),
      ],
    );

    return routeRead.when(
      data: (routeRead) => settings.when(
        data: (settings) {
          final connectedWall = ref.watch(WallProvider(settings.wallId));

          return connectedWall.when(
            data: (connectedWall) => HookBuilder(
              builder: (context) {
                final startingModule = useState<int?>(null);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: RouteWidget(route: routeRead)),
                    const Divider(thickness: 2),
                    Expanded(
                      child: RouteOnWallPreview(
                        wall: connectedWall,
                        onStartingModuleSelect: (moduleNumber) =>
                            startingModule.value =
                                startingModule.value == moduleNumber
                                ? null
                                : moduleNumber,
                        route: routeRead,
                        startingModule: startingModule.value,
                      ),
                    ),
                    Padding(
                      padding: const Pad(all: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          onDeletePressed == null
                              ? const SizedBox()
                              : FutureButton(
                                  onPressed: onDeletePressed,
                                  child: const Text("Удалить"),
                                ),
                          Box.gap(8),
                          ElevatedButton(
                            onPressed: () => showGeneralDialog(
                              context: context,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      editDialog,
                            ),
                            child: const Text("Редактировать"),
                          ),
                          Box.gap(8),
                          ElevatedButton(
                            onPressed: startingModule.value == null
                                ? null
                                : () async => await ref
                                      .read(wallStateProvider(0, 0).notifier)
                                      .showRoute(
                                        routeRead,
                                        startingModule.value!,
                                      ),
                            child: const Text("Применить"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            error: (error, stackTrace) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: RouteWidget(route: routeRead)),
                const Divider(thickness: 2),
                ErrorText(error: error),
              ],
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator.adaptive()),
          );
        },
        error: (error, stackTrace) => ErrorText(error: error),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
      error: (error, stackTrace) => ErrorText(error: error),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

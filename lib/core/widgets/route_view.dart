import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:edwall_admin/core/providers/route.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/error_text.dart';
import 'package:edwall_admin/core/widgets/route_widget.dart';
import 'package:edwall_admin/features/routes/widgets/route_on_wall_preview.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RouteView extends ConsumerWidget {
  final Route route;
  const RouteView(this.route, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeRead = ref.watch(routeProvider(route.id));
    final settings = ref.watch(settingsProvider);

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
                      padding: const Pad(bottom: 8, horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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

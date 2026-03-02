import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:edwall_admin/core/infrastructure/custom_toast.dart';
import 'package:edwall_admin/core/providers/active_holds.dart';
import 'package:edwall_admin/core/providers/route.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/core/widgets/default_app_bar.dart';
import 'package:edwall_admin/features/groups/widgets/color_select_button.dart';
import 'package:edwall_admin/features/groups/widgets/error_column.dart';
import 'package:edwall_admin/features/programme/domain/programme.dart';
import 'package:edwall_admin/features/programmes/domain/programmes.dart';
import 'package:edwall_admin/features/routes/domain/routes.dart';
import 'package:edwall_admin/features/sandbox/widgets/active_wall_widget.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class RouteModifyPage extends HookConsumerWidget {
  final int? routeId;
  final int programmeId;

  const RouteModifyPage({super.key, this.routeId, required this.programmeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final routeAsyncValue = routeId == null
        ? AsyncValue.data(null)
        : ref.watch(RouteProvider(routeId!));
    final programmeAsyncValue = ref.watch(programmeProvider(programmeId));
    final settings = ref.watch(settingsProvider).requireValue;
    final wallAsyncValue = ref.watch(wallProvider(settings.wallId));
    final error =
        wallAsyncValue.error ??
        routeAsyncValue.error ??
        programmeAsyncValue.error;
    final isLoading =
        wallAsyncValue.isLoading ||
        routeAsyncValue.isLoading ||
        programmeAsyncValue.isLoading;
    final programme = programmeAsyncValue.valueOrNull;
    final route = routeAsyncValue.valueOrNull;
    final wall = wallAsyncValue.valueOrNull;

    final unsafe = useState(false);
    final name = useTextEditingController(text: route?.name ?? '');
    final description = useTextEditingController(
      text: route?.description ?? '',
    );

    useEffect(() {
      if (route != null) {
        ref.read(wallStateProvider(0, 0).notifier).showRoute(route, 0);
        name.text = route.name;
        description.text = route.description;
      } else if (routeId == null && wall != null) {
        ref.read(wallStateProvider(0, 0).notifier).clear(wall);
      }
      return null;
    }, [route, wallAsyncValue]);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    if (error != null) {
      return Scaffold(
        body: ErrorColumn(
          error: error,
          onRetry: () {
            ref.invalidate(programmeProvider(programmeId));
            ref.invalidate(wallProvider(settings.wallId));
            if (routeId != null) {
              ref.invalidate(routeProvider(routeId!));
            }
          },
        ),
      );
    }

    wall!;
    programme!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DefaultAppBar(title: Text('Раздел: ${programme.name}')),
          ),
          SliverPadding(
            padding: Pad(top: 8, left: 32, right: 48),
            sliver: SliverList.list(
              children: [
                Text(
                  'Название задания',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Box.gap(16),
                TextField(
                  controller: name,
                  decoration: InputDecoration(hintText: 'Название задания'),
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
                  decoration: InputDecoration(hintText: 'Описание задания'),
                  maxLines: 5,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          SliverList.list(
            children: [
              Box.gap(32),
              SizedBox(
                height: 300,
                child: ActiveWallWidget(
                  wall: wall,
                  editable: true,
                  padding: Pad(left: 32, right: 48),
                ),
              ),
              Box.gap(16),
              SizedBox(
                height: 64,
                child: ListView(
                  key: PageStorageKey('buttons_list'),
                  padding: Pad(left: 32, right: 48, bottom: 16),
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (route != null) ...[
                      (unsafe.value ? ElevatedButton.new : OutlinedButton.new)(
                        onPressed: unsafe.value
                            ? () async {
                                await ref
                                    .read(routesProvider().notifier)
                                    .delete(route.id);
                                if (context.mounted) {
                                  context.router.pop();
                                }
                              }
                            : null,
                        child: Text("Удалить задание"),
                      ),
                      IconButton(
                        onPressed: () => unsafe.value = !unsafe.value,
                        icon: Icon(
                          unsafe.value
                              ? Icons.lock_open_outlined
                              : Icons.lock_outline,
                        ),
                      ),
                      Box.gap(16),
                    ],
                    ...holdColors.indexed.map(
                      (e) => Padding(
                        padding: Pad(left: e.$1 == 0 ? 0 : 16),
                        child: ColorSelectButton(
                          color: e.$2,
                          name: ["РУКА", "СТАРТ", "ФИНИШ", "НОГА", "ДОП"][e.$1],
                        ),
                      ),
                    ),
                    if (route != null) ...[
                      Box.gap(32),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(0, 40)),
                        ),
                        onPressed: () async {
                          await ref
                              .read(wallStateProvider(0, 0).notifier)
                              .showRoute(route, 0);
                        },
                        child: Text("ВЕРНУТЬ К ИСХОДНОМУ"),
                      ),
                    ],
                    Box.gap(32),
                    ElevatedButton(
                      onPressed: () async {
                        final holds = (await ref.read(
                          activeHoldsProvider.future,
                        )).map((e) => (e.$1.id, e.$2)).toList();
                        try {
                          if (route == null) {
                            final newRoute = RouteBase(
                              name: name.text,
                              description: description.text,
                              difficult: '',
                              numberOfModules: 4,
                              hardnessId: null,
                            );
                            final addedRoute = await ref
                                .read(routesProvider().notifier)
                                .add(newRoute, holds);
                            ref
                                .read(programmesProvider().notifier)
                                .modify(
                                  programme.id,
                                  ProgrammeUpdate(),
                                  programme.routes.map((r) => r.id).toList() +
                                      [addedRoute.id],
                                );
                          } else {
                            final newRoute = RouteUpdate(
                              name: name.text,
                              description: description.text,
                            );
                            await ref
                                .read(routesProvider().notifier)
                                .modify(route.id, newRoute, holds);
                            ref.invalidate(programmeProvider(programmeId));
                          }
                        } on ExceptionWithMessage catch (e) {
                          CustomToast(context).showTextFailureToast(e.message);
                          return;
                        }
                        if (context.mounted) {
                          context.router.pop();
                        }
                      },
                      child: Text("СОХРАНИТЬ ИЗМЕНЕНИЯ"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
